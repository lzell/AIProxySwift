//
//  AnthropicToolResultBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// A tool result content block, containing the result of a tool execution.
nonisolated public struct AnthropicToolResultBlockParam: Encodable, Sendable {
    /// The ID of the tool use this result corresponds to.
    public let toolUseId: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// The content of the tool result.
    public let content: AnthropicToolResultContent?

    /// Whether the tool execution resulted in an error.
    public let isError: Bool?

    private enum CodingKeys: String, CodingKey {
        case type
        case toolUseId = "tool_use_id"
        case cacheControl = "cache_control"
        case content
        case isError = "is_error"
    }

    public init(
        toolUseId: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        content: AnthropicToolResultContent? = nil,
        isError: Bool? = nil
    ) {
        self.toolUseId = toolUseId
        self.cacheControl = cacheControl
        self.content = content
        self.isError = isError
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("tool_result", forKey: .type)
        try container.encode(toolUseId, forKey: .toolUseId)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(isError, forKey: .isError)
    }
}

/// The content of a tool result, either a string or array of content blocks.
nonisolated public enum AnthropicToolResultContent: Encodable, Sendable {
    case text(String)
    case blocks([AnthropicToolResultContentBlock])

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let string):
            try container.encode(string)
        case .blocks(let blocks):
            try container.encode(blocks)
        }
    }
}

/// A content block that can appear in a tool result.
nonisolated public enum AnthropicToolResultContentBlock: Encodable, Sendable {
    case text(AnthropicTextBlockParam)
    case image(AnthropicImageBlockParam)
    case searchResult(AnthropicSearchResultBlockParam)
    case document(AnthropicDocumentBlockParam)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let block):
            try block.encode(to: encoder)
        case .image(let block):
            try block.encode(to: encoder)
        case .searchResult(let block):
            try block.encode(to: encoder)
        case .document(let block):
            try block.encode(to: encoder)
        }
    }
}
