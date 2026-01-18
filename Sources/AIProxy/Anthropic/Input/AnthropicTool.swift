//
//  AnthropicTool.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// A custom client tool definition. See `AnthropicToolUnion` for built-in tools.
///
/// Represents Anthropic's `Tool` object:
/// https://console.anthropic.com/docs/en/api/messages#tool
nonisolated public struct AnthropicTool: Encodable, Sendable {
    /// Description of what this tool does.
    ///
    /// Tool descriptions should be as detailed as possible. The more information that the model
    /// has about what the tool is and how to use it, the better it will perform. You can use
    /// natural language descriptions to reinforce important aspects of the tool input JSON schema.
    public let description: String

    /// A JSON schema for this tool's input.
    /// This defines the shape of the `input` that your tool accepts and that the model will
    /// produce. For example:
    ///
    ///     {
    ///       "type": "object",
    ///       "properties": {
    ///         "location": {
    ///           "type": "string",
    ///           "description": "The city and state, e.g. San Francisco, CA"
    ///         }
    ///       },
    ///       "required": ["location"]
    ///     }
    public let inputSchema: [String: AIProxyJSONValue]

    /// Name of the tool.
    ///
    /// This is how the tool will be called by the model and in `tool_use` blocks.
    public let name: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    private enum CodingKeys: String, CodingKey {
        case type
        case description
        case inputSchema = "input_schema"
        case name
        case cacheControl = "cache_control"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("custom", forKey: .type)
        try container.encode(inputSchema, forKey: .inputSchema)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(description, forKey: .description)
    }

    public init(
        description: String,
        inputSchema: [String: AIProxyJSONValue],
        name: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil
    ) {
        self.description = description
        self.inputSchema = inputSchema
        self.name = name
        self.cacheControl = cacheControl
    }
}
