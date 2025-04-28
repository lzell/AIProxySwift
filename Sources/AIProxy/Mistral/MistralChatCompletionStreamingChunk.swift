//
//  MistralChatCompletionStreamingChunk.swift
//
//
//  Created by Lou Zell on 11/24/24.
//

import Foundation

/// Docstrings from: https://platform.openai.com/docs/api-reference/chat/streaming
public struct MistralChatCompletionStreamingChunk: Decodable {
    /// A list of chat completion capphoices. Can contain more than one elements if
    /// MistralChatCompletionRequestBody's `n` property is greater than 1. Can also be empty for
    /// the last chunk, which contains usage information only.
    public let choices: [Choice]

    /// This property is nil for all chunks except for the last chunk, which contains the token
    /// usage statistics for the entire request.
    public let usage: MistralChatUsage?
}

// MARK: - Chunk.Choice
extension MistralChatCompletionStreamingChunk {
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
extension MistralChatCompletionStreamingChunk.Choice {
    public struct Delta: Codable {
        public let role: String?
        public let content: String?
    }
}
