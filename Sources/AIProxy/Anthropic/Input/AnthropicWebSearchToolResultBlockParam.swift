//
//  AnthropicWebSearchToolResultBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// A web search tool result content block.
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_result_block_param
nonisolated public struct AnthropicWebSearchToolResultBlockParam: Encodable, Sendable {
    /// The content of the web search result.
    public let content: AnthropicWebSearchToolResultContent

    /// The ID of the tool use this result corresponds to.
    public let toolUseId: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    private enum CodingKeys: String, CodingKey {
        case type
        case content
        case toolUseId = "tool_use_id"
        case cacheControl = "cache_control"
    }

    public init(
        content: AnthropicWebSearchToolResultContent,
        toolUseId: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil
    ) {
        self.content = content
        self.toolUseId = toolUseId
        self.cacheControl = cacheControl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("web_search_tool_result", forKey: .type)
        try container.encode(content, forKey: .content)
        try container.encode(toolUseId, forKey: .toolUseId)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}
