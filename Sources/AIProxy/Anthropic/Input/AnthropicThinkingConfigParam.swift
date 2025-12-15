//
//  AnthropicThinkingConfigParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Configuration for enabling Claude's extended thinking.
///
/// When enabled, responses include `thinking` content blocks showing Claude's thinking process
/// before the final answer. Requires a minimum budget of 1,024 tokens and counts towards your
/// `max_tokens` limit.
///
/// See [extended thinking](https://docs.claude.com/en/docs/build-with-claude/extended-thinking) for details.
nonisolated public enum AnthropicThinkingConfigParam: Encodable, Sendable {
    /// Enable extended thinking with a token budget.
    ///
    /// - Parameter budgetTokens: Determines how many tokens Claude can use for its internal
    ///   reasoning process. Larger budgets can enable more thorough analysis for complex problems,
    ///   improving response quality. Must be ≥1024 and less than `max_tokens`.
    case enabled(budgetTokens: Int)

    /// Disable extended thinking.
    case disabled

    private enum CodingKeys: String, CodingKey {
        case type
        case budgetTokens = "budget_tokens"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .enabled(let budgetTokens):
            try container.encode("enabled", forKey: .type)
            try container.encode(budgetTokens, forKey: .budgetTokens)
        case .disabled:
            try container.encode("disabled", forKey: .type)
        }
    }
}
