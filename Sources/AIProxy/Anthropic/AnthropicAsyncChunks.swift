//
//  AnthropicAsyncChunks.swift
//
//
//  Created by Lou Zell on 10/7/24.
//

import Foundation

/// Iterate the streaming chunks using the following pattern:
///
///     let stream = try await anthropicService.streamingMessageRequest(...)
///
///     for try await chunk in stream {
///         switch chunk {
///         case .text(let text):
///             print(text)
///         case .toolUse(name: let toolName, input: let toolInput):
///             print("Claude wants to call tool \(toolName) with input \(toolInput)")
///         }
///     }
nonisolated public struct AnthropicAsyncChunks: AsyncSequence, Sendable {
    public typealias Element = AnthropicMessageStreamingChunk
    private let asyncLines: AsyncLineSequence<URLSession.AsyncBytes>

    internal init(asyncLines: AsyncLineSequence<URLSession.AsyncBytes>) {
        self.asyncLines = asyncLines
    }

    nonisolated public struct AsyncIterator: AsyncIteratorProtocol {
        var asyncBytesIterator: AsyncLineSequence<URLSession.AsyncBytes>.AsyncIterator

        /// This buffers up any tool calls that are part of the streaming response before
        /// emitting the next streaming chunk. That is, tool calls are not emitted to the
        /// caller as partial values. I see no value in a partial tool call, as we don't have
        /// enough context to form the full local function call (we don't have the arguments!)
        /// until the full tool call is buffered in. If you have a use case where partial tool
        /// calls are necessary, please reach out to me.
        ///
        /// Text chunks are immediately emitted.
        mutating public func next() async throws -> AnthropicMessageStreamingChunk? {
            var toolUseAccumulator = ""
            var toolName: String? = nil
            while true {
                guard let value = try await self.asyncBytesIterator.next() else {
                    return nil // No more streaming lines to consume
                }
                if value.starts(with: #"data: {"type":"content_block_start""#) {
                    if let blockStart = AnthropicMessageStreamingContentBlockStart.from(line: value) {
                        if case .toolUse(name: let name) = blockStart.contentBlock {
                            toolName = name
                        }
                    }
                }
                if value.starts(with: #"data: {"type":"content_block_stop""#) {
                    if let toolName = toolName {
                        return .toolUse(
                            name: toolName,
                            input: try [String: AIProxyJSONValue].deserialize(from: toolUseAccumulator).untypedDictionary
                        )
                    }
                }
                if let block = AnthropicMessageStreamingDeltaBlock.from(line: value) {
                    switch block.delta {
                    case .text(let string):
                        return .text(string)
                    case .toolUse(let string):
                        toolUseAccumulator += string
                    }
                }
            }
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(asyncBytesIterator: asyncLines.makeAsyncIterator())
    }
}
