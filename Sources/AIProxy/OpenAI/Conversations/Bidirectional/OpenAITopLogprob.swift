//
//  OpenAITopLogprob.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: TopLogProb, version 2.3.0, line 64919
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-logprobs-top_logprobs

/// The top log probability of a token.
nonisolated public struct OpenAITopLogprob: Codable, Sendable {
    /// The bytes of the token.
    public let bytes: [Int]

    /// The log probability of the token.
    public let logprob: Double

    /// The token.
    public let token: String

    /// Creates a new top log probability.
    /// - Parameters:
    ///   - bytes: The bytes of the token.
    ///   - logprob: The log probability of the token.
    ///   - token: The token.
    public init(
        bytes: [Int],
        logprob: Double,
        token: String
    ) {
        self.bytes = bytes
        self.logprob = logprob
        self.token = token
    }

    private enum CodingKeys: String, CodingKey {
        case bytes
        case logprob
        case token
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bytes = try container.decode([Int].self, forKey: .bytes)
        self.logprob = try container.decode(Double.self, forKey: .logprob)
        self.token = try container.decode(String.self, forKey: .token)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bytes, forKey: .bytes)
        try container.encode(logprob, forKey: .logprob)
        try container.encode(token, forKey: .token)
    }
}
