//
//  GroqChatCompletionStreamingChunk.swift
//
//
//  Created by Lou Zell on 10/1/24.
//

import Foundation

/// Docstrings from: https://platform.openai.com/docs/api-reference/chat/streaming
public struct GroqChatCompletionStreamingChunk: Decodable {
    /// A list of chat completion choices. Can contain more than one elements if
    /// OpenAIChatCompletionRequestBody's `n` property is greater than 1. Can also be empty for
    /// the last chunk, which contains usage information only.
    public let choices: [Choice]
}

// MARK: - Chunk.Choice
extension GroqChatCompletionStreamingChunk {
    public struct Choice: Codable {
        public let delta: Delta
        public let finishReason: String?

        private enum CodingKeys: String, CodingKey {
            case delta
            case finishReason = "finish_reason"
        }
    }
}

// MARK: - Chunk.Choice.Delta
extension GroqChatCompletionStreamingChunk.Choice {
    public struct Delta: Codable {
        public let role: String?
        public let content: String?
    }
}

extension GroqChatCompletionStreamingChunk {
    /// Creates a ChatCompletionChunk from a streamed line of the /openai//v1/chat/completions response
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
              let chunk = try? JSONDecoder().decode(
                GroqChatCompletionStreamingChunk.self,
                from: chunkJSON
              ) else
        {
            aiproxyLogger.warning("Received unexpected JSON from aiproxy: \(line)")
            return nil
        }

        // aiproxyLogger.debug("Received a chunk: \(line)")
        return chunk
    }
}
