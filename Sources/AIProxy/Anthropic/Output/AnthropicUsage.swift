//
//  AnthropicUsage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `Usage` object:
/// https://console.anthropic.com/docs/en/api/messages#usage
nonisolated public struct AnthropicUsage: Decodable, Sendable {
    /// The number of input tokens which were used.
    public let inputTokens: Int

    /// The number of output tokens which were used.
    public let outputTokens: Int

    /// Breakdown of cached tokens by TTL.
    public let cacheCreation: AnthropicCacheCreation?

    /// The number of input tokens used to create the cache entry.
    public let cacheCreationInputTokens: Int?

    /// The number of input tokens read from the cache.
    public let cacheReadInputTokens: Int?

    /// The number of server tool requests.
    public let serverToolUse: AnthropicServerToolUsage?

    /// If the request used the priority, standard, or batch tier.
    public let serviceTier: AnthropicServiceTier?

    private enum CodingKeys: String, CodingKey {
        case cacheCreation = "cache_creation"
        case cacheCreationInputTokens = "cache_creation_input_tokens"
        case cacheReadInputTokens = "cache_read_input_tokens"
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
        case serverToolUse = "server_tool_use"
        case serviceTier = "service_tier"
    }
}

