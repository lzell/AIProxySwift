//
//  TogetherAIChatCompletionStreamingChunk.swift
//
//
//  Created by Lou Zell on 8/16/24.
//

import Foundation

public struct TogetherAIChatCompletionStreamingChunk: Decodable {
    /// Generated choices
    public let choices: [TogetherAIStreamingChunkChoice]

    /// Time in seconds since unix epoch
    public let created: Int

    /// The model used to create the chunk
    public let model: String

    /// Usage information, which is only included on the last chunk of the stream
    public let usage: TogetherAIChatUsage?

    internal static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: data)
    }

    internal static func deserialize(fromLine line: String) throws -> Self? {
        guard line.hasPrefix("data: ") else {
            aiproxyLogger.warning("Received unexpected line from aiproxy: \(line)")
            return nil
        }

        guard line != "data: [DONE]" else {
            aiproxyLogger.debug("Streaming response has finished")
            return nil
        }

        guard let chunkJSON = line.dropFirst(6).data(using: .utf8),
              let chunk = try? self.deserialize(from: chunkJSON) else
        {
            aiproxyLogger.warning("Received unexpected JSON from aiproxy: \(line)")
            return nil
        }

        return chunk
    }

    internal static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
    }
}

public struct TogetherAIStreamingChunkChoice: Decodable {
    /// The text for this generation is within the 'delta' property
    public let delta: TogetherAIStreamingChunkDelta

    /// The reason the stream ended
    public let finishReason: TogetherAIFinishReason?
}

public struct TogetherAIStreamingChunkDelta: Decodable {
    /// The text of the generation
    public let content: String

    /// The role of the generation
    public let role: TogetherAIRole
}

extension TogetherAIChatCompletionStreamingChunk {
    /// Creates a TogetherAIChatCompletionStreamingChunk from a streamed line of the /v1/chat/completions response
    internal static func from(line: String) -> Self? {
        guard line.hasPrefix("data: ") else {
            aiproxyLogger.warning("Received unexpected line from aiproxy: \(line)")
            return nil
        }

        guard line != "data: [DONE]" else {
            aiproxyLogger.debug("Streaming response has finished")
            return nil
        }

        guard let chunkJSON = line.dropFirst(6).data(using: .utf8),
              let chunk = try? TogetherAIChatCompletionStreamingChunk.deserialize(from: chunkJSON) else
        {
            aiproxyLogger.warning("Received unexpected JSON from aiproxy: \(line)")
            return nil
        }

        return chunk
    }
}
