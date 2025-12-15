//
//  AnthropicToolUseBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// A tool use content block, representing the model's request to use a tool.
nonisolated public struct AnthropicToolUseBlockParam: Encodable, Sendable {
    /// The unique identifier for this tool use.
    public let id: String

    /// The input to the tool as a JSON object.
    public let input: [String: AIProxyJSONValue]

    /// The name of the tool being used.
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
        try container.encode("tool_use", forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(input, forKey: .input)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}

