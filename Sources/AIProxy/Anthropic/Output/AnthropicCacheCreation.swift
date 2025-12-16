//
//  AnthropicCacheCreation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CacheCreation` object:
/// https://console.anthropic.com/docs/en/api/messages#cache_creation
nonisolated public struct AnthropicCacheCreation: Decodable, Sendable {
    public let ephemeral1hInputTokens: Int
    public let ephemeral5mInputTokens: Int

    private enum CodingKeys: String, CodingKey {
        case ephemeral1hInputTokens = "ephemeral_1h_input_tokens"
        case ephemeral5mInputTokens = "ephemeral_5m_input_tokens"
    }
}
