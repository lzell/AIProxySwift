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

    internal static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: data)
    }

    internal static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
    }
}

public struct TogetherAIChatCompletionChoice: Decodable {

    public let message: TogetherAIMessage

    /// This must be optional, because JSON mode responses do not contain a finish reason
    public let finishReason: TogetherAIFinishReason?

    public let logprobs: TogetherAILogprobs?
}

public enum TogetherAIFinishReason: String, Decodable {
    case eos
    case stop
    case length
    case toolCalls
}

public struct TogetherAILogprobs: Decodable {
    /// List of token strings
    public let tokens: [String]

    /// List of token log probabilities
    public let tokenLogprobs: [Double]
}

public struct TogetherAIChatUsage: Decodable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
}
