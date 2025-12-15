//
//  AnthropicServerToolUseBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// Represents Anthropic's `ServerToolUseBlockParam` object:
/// https://console.anthropic.com/docs/en/api/messages#server_tool_use_block_param
nonisolated public struct AnthropicServerToolUseBlockParam: Encodable, Sendable {
    /// The unique identifier for this tool use.
    public let id: String

    /// The input to the tool as a JSON object.
    public let input: [String: AIProxyJSONValue]

    /// The name of the server tool (e.g., "web_search").
    public let name: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case input
        case name
        case cacheControl = "cache_control"
    }

    public init(
        id: String,
        input: [String: AIProxyJSONValue],
        name: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil
    ) {
        self.id = id
        self.input = input
        self.name = name
        self.cacheControl = cacheControl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("server_tool_use", forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(input, forKey: .input)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}
