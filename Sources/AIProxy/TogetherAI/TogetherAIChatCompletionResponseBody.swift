//
//  TogetherAIChatCompletionResponseBody.swift
//
//
//  Created by Lou Zell on 8/15/24.
//

import Foundation

/// Format taken from here:
/// https://docs.together.ai/reference/chat-completions-1
nonisolated public struct TogetherAIChatCompletionResponseBody: Decodable, Sendable {

    /// Generation choices
    public let choices: [TogetherAIChatCompletionChoice]

    /// Timestamp in seconds since unix epoch
    public let created: Int

    /// Response ID
    public let id: String

    /// The model used to create the chat completion
    public let model: String

    public let usage: TogetherAIChatUsage?
    
    public init(choices: [TogetherAIChatCompletionChoice], created: Int, id: String, model: String, usage: TogetherAIChatUsage?) {
        self.choices = choices
        self.created = created
        self.id = id
        self.model = model
        self.usage = usage
    }
}

nonisolated public struct TogetherAIChatCompletionChoice: Decodable, Sendable {

    public let message: TogetherAIMessage

    /// This must be optional, because JSON mode responses do not contain a finish reason
    public let finishReason: TogetherAIFinishReason?

    public let logprobs: TogetherAILogprobs?

    private enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case logprobs
    }
    
    public init(message: TogetherAIMessage, finishReason: TogetherAIFinishReason?, logprobs: TogetherAILogprobs?) {
        self.message = message
        self.finishReason = finishReason
        self.logprobs = logprobs
    }
}

nonisolated public enum TogetherAIFinishReason: String, Decodable, Sendable {
    case eos
    case stop
    case length
    case toolCalls = "tool_calls"
}

nonisolated public struct TogetherAILogprobs: Decodable, Sendable {
    /// List of token strings
    public let tokens: [String]

    /// List of token log probabilities
    public let tokenLogprobs: [Double]

    private enum CodingKeys: String, CodingKey {
        case tokens
        case tokenLogprobs = "token_logprobs"
    }
    
    public init(tokens: [String], tokenLogprobs: [Double]) {
        self.tokens = tokens
        self.tokenLogprobs = tokenLogprobs
    }
}

nonisolated public struct TogetherAIChatUsage: Decodable, Sendable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
    
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}
