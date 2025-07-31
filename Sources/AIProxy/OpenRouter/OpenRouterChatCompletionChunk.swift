//
//  OpenRouterChatCompletionChunk.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/24.
//

public struct OpenRouterChatCompletionChunk: Decodable {
    /// A list of chat completion choices. Can contain more than one elements if
    /// OpenRouterChatCompletionRequestBody's `n` property is greater than 1. Can also be empty for
    /// the last chunk, which contains usage information only.
    public let choices: [Choice]

    /// The model used for the chat completion.
    public let model: String?

    /// The provider used to fulfill the chat completion.
    public let provider: String?

    /// This property is nil for all chunks except for the last chunk, which contains the token
    /// usage statistics for the entire request.
    public let usage: OpenRouterChatCompletionResponseBody.Usage?
    
    public init(choices: [Choice], model: String?, provider: String?, usage: OpenRouterChatCompletionResponseBody.Usage?) {
        self.choices = choices
        self.model = model
        self.provider = provider
        self.usage = usage
    }
}

// MARK: Chunk.Choice
extension OpenRouterChatCompletionChunk {
    public struct Choice: Decodable {
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

// MARK: Chunk.Choice.Delta
extension OpenRouterChatCompletionChunk.Choice {
    public struct Delta: Codable {
        public let role: String

        /// Output content. For reasoning models, these chunks arrive after `reasoning` has finished.
        public let content: String?

        /// Reasoning content. For reasoning models, these chunks arrive before `content`.
        public let reasoning: String?

        public let toolCalls: [ToolCall]?

        public init(
            role: String,
            content: String? = nil,
            reasoning: String? = nil,
            toolCalls: [OpenRouterChatCompletionChunk.Choice.Delta.ToolCall]? = nil
        ) {
            self.role = role
            self.content = content
            self.reasoning = reasoning
            self.toolCalls = toolCalls
        }

        private enum CodingKeys: String, CodingKey {
            case role
            case content
            case reasoning
            case toolCalls = "tool_calls"
        }
    }
}

extension OpenRouterChatCompletionChunk.Choice.Delta {
    public struct ToolCall: Codable {
        public let index: Int?
        /// The function that the model instructs us to call
        public let function: Function?
    }
}

extension OpenRouterChatCompletionChunk.Choice.Delta.ToolCall {
    public struct Function: Codable {
        /// The name of the function to call.
        public let name: String?

        /// The arguments to call the function with.
        public let arguments: String?
    }
}
