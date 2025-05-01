//
//  TogetherAIChatCompletionResponseBody.swift
//
//
//  Created by Lou Zell on 8/15/24.
//

import Foundation

/// Format taken from here:
/// https://docs.together.ai/reference/chat-completions-1
public struct TogetherAIChatCompletionResponseBody: Decodable {

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

public struct TogetherAIChatCompletionChoice: Decodable {

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

public enum TogetherAIFinishReason: String, Decodable {
    case eos
    case stop
    case length
    case toolCalls = "tool_calls"
}

public struct TogetherAILogprobs: Decodable {
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

public struct TogetherAIChatUsage: Decodable {
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
