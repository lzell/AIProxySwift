//
//  MistralChatUsage.swift
//
//  Created by Lou Zell on 11/24/24.
//

import Foundation

nonisolated public struct MistralChatUsage: Decodable, Sendable {
    /// Number of tokens in the generated completion.
    public let completionTokens: Int?

    /// Number of tokens in the prompt.
    public let promptTokens: Int?

    /// Total number of tokens used in the request (prompt + completion).
    public let totalTokens: Int?

    private enum CodingKeys: String, CodingKey {
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
        case totalTokens = "total_tokens"
    }
}
