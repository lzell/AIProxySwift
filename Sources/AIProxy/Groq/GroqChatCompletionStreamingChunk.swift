//
//  GroqChatCompletionStreamingChunk.swift
//
//
//  Created by Lou Zell on 10/1/24.
//

import Foundation

/// Docstrings from: https://platform.openai.com/docs/api-reference/chat/streaming
nonisolated public struct GroqChatCompletionStreamingChunk: Decodable, Sendable {
    /// A list of chat completion choices. Can contain more than one elements if
    /// OpenAIChatCompletionRequestBody's `n` property is greater than 1. Can also be empty for
    /// the last chunk, which contains usage information only.
    public let choices: [Choice]
    
    public init(choices: [Choice]) {
        self.choices = choices
    }
}

// MARK: - Chunk.Choice
extension GroqChatCompletionStreamingChunk {
    nonisolated public struct Choice: Codable, Sendable {
        public let delta: Delta
        public let finishReason: String?
        
        public init(delta: Delta, finishReason: String?) {
            self.delta = delta
            self.finishReason = finishReason
        }

        private enum CodingKeys: String, CodingKey {
            case delta
            case finishReason = "finish_reason"
        }
    }
}

// MARK: - Chunk.Choice.Delta
extension GroqChatCompletionStreamingChunk.Choice {
    nonisolated public struct Delta: Codable, Sendable {
        public let role: String?
        public let content: String?
        
        public init(role: String?, content: String?) {
            self.role = role
            self.content = content
        }
    }
}
