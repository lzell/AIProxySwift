//
//  AnthropicSystemTextBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//


/// A text block in a system prompt.
nonisolated public struct AnthropicSystemTextBlockParam: Encodable, Sendable {
    /// The text content.
    public let text: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// Citations for this text block.
    public let citations: [AnthropicTextCitationParam]?

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case cacheControl = "cache_control"
        case citations
    }

    public init(
        text: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        citations: [AnthropicTextCitationParam]? = nil
    ) {
        self.text = text
        self.cacheControl = cacheControl
        self.citations = citations
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("text", forKey: .type)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(citations, forKey: .citations)
    }
}
