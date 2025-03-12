//
//  OpenAIChatUsage.swift
//
//
//  Created by Lou Zell on 9/19/24.
//

import Foundation

/// Docstrings from:
/// https://platform.openai.com/docs/api-reference/chat/object#chat/object-usage
public struct OpenAIChatUsage: Decodable {
    /// Number of tokens in the generated completion.
    public let completionTokens: Int?

    /// Number of tokens in the prompt.
    public let promptTokens: Int?

    /// Total number of tokens used in the request (prompt + completion).
    public let totalTokens: Int?

    /// Breakdown of tokens used in a completion.
    public let completionTokensDetails: Details?

    private enum CodingKeys: String, CodingKey {
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
        case totalTokens = "total_tokens"
        case completionTokensDetails = "completion_tokens_details"
    }
}

// MARK: -
extension OpenAIChatUsage {
    public struct Details: Decodable {
        /// Tokens generated by the model for reasoning.
        public let reasoningTokens: Int?

        private enum CodingKeys: String, CodingKey {
            case reasoningTokens = "reasoning_tokens"
        }
    }
}
