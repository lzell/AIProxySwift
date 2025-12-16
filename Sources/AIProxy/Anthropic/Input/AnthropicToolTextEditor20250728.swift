//
//  AnthropicToolTextEditor20250728.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Text editor tool for string replacement operations (version 2025-07-28).
/// https://console.anthropic.com/docs/en/api/messages#tool_text_editor_20250728
nonisolated public struct AnthropicToolTextEditor20250728: Encodable, Sendable {
    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// Maximum number of characters to display when viewing a file.
    /// If not specified, defaults to displaying the full file.
    public let maxCharacters: Int?

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case cacheControl = "cache_control"
        case maxCharacters = "max_characters"
    }

    public init(
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        maxCharacters: Int? = nil
    ) {
        self.cacheControl = cacheControl
        self.maxCharacters = maxCharacters
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("str_replace_based_edit_tool", forKey: .name)
        try container.encode("text_editor_20250728", forKey: .type)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(maxCharacters, forKey: .maxCharacters)
    }
}
