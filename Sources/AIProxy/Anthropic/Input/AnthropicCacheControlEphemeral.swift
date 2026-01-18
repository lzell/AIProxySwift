//
//  AnthropicCacheControlEphemeral.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CacheControlEphemeral` object:
/// https://console.anthropic.com/docs/en/api/messages#cache_control_ephemeral
nonisolated public struct AnthropicCacheControlEphemeral: Encodable, Sendable {

    /// The time-to-live for the cache control breakpoint.
    /// Defaults to 5 minutes if not supplied
    public let ttl: TTL?

    private enum CodingKeys: String, CodingKey {
        case type
        case ttl
    }

    public init(ttl: TTL? = nil) {
        self.ttl = ttl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("ephemeral", forKey: .type)
        try container.encodeIfPresent(ttl, forKey: .ttl)
    }
}

extension AnthropicCacheControlEphemeral {
    /// Time-to-live options for cache control.
    nonisolated public enum TTL: String, Encodable, Sendable {
        case fiveMinutes = "5m"
        case oneHour = "1h"
    }
}
