//
//  OpenAILogprob.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: LogProb, version 2.3.0, line 64936
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-logprobs

/// The log probability of a token.
nonisolated public struct OpenAILogprob: Codable, Sendable {
    /// The bytes that were used to generate the log probability.
    public let bytes: [Int]

    /// The log probability of the token.
    public let logprob: Double

    /// The token that was used to generate the log probability.
    public let token: String

    /// Top log probabilities for alternative tokens.
    public let topLogprobs: [OpenAITopLogprob]

    /// Creates a new log probability.
    /// - Parameters:
    ///   - bytes: The bytes that were used to generate the log probability.
    ///   - logprob: The log probability of the token.
    ///   - token: The token that was used to generate the log probability.
    ///   - topLogprobs: Top log probabilities for alternative tokens.
    public init(
        bytes: [Int],
        logprob: Double,
        token: String,
        topLogprobs: [OpenAITopLogprob]
    ) {
        self.bytes = bytes
        self.logprob = logprob
        self.token = token
        self.topLogprobs = topLogprobs
    }

    private enum CodingKeys: String, CodingKey {
        case bytes
        case logprob
        case token
        case topLogprobs = "top_logprobs"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bytes = try container.decode([Int].self, forKey: .bytes)
        self.logprob = try container.decode(Double.self, forKey: .logprob)
        self.token = try container.decode(String.self, forKey: .token)
        self.topLogprobs = try container.decode([OpenAITopLogprob].self, forKey: .topLogprobs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bytes, forKey: .bytes)
        try container.encode(logprob, forKey: .logprob)
        try container.encode(token, forKey: .token)
        try container.encode(topLogprobs, forKey: .topLogprobs)
    }
}
