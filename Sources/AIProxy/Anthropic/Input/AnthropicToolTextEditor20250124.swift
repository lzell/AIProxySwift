//
//  AnthropicToolTextEditor20250124.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//


/// Text editor tool for string replacement operations (version 2025-01-24).
/// https://console.anthropic.com/docs/en/api/messages#tool_text_editor_20250124
nonisolated public struct AnthropicToolTextEditor20250124: Encodable, Sendable {
    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case cacheControl = "cache_control"
    }

    public init(cacheControl: AnthropicCacheControlEphemeral? = nil) {
        self.cacheControl = cacheControl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("str_replace_editor", forKey: .name)
        try container.encode("text_editor_20250124", forKey: .type)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}
