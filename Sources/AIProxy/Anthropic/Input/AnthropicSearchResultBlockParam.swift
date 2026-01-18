//
//  AnthropicSearchResultBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// Represents Anthropic's `SearchResultBlockParam` object:
/// https://console.anthropic.com/docs/en/api/messages#search_result_block_param
nonisolated public struct AnthropicSearchResultBlockParam: Encodable, Sendable {
    /// The content of the search result as text blocks.
    public let content: [AnthropicTextBlockParam]

    /// The source of the search result.
    public let source: String

    /// The title of the search result.
    public let title: String

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// Configuration for enabling citations.
    public let citations: AnthropicCitationsConfigParam?

    private enum CodingKeys: String, CodingKey {
        case type
        case content
        case source
        case title
        case cacheControl = "cache_control"
        case citations
    }

    public init(
        content: [AnthropicTextBlockParam],
        source: String,
        title: String,
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        citations: AnthropicCitationsConfigParam? = nil
    ) {
        self.content = content
        self.source = source
        self.title = title
        self.cacheControl = cacheControl
        self.citations = citations
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("search_result", forKey: .type)
        try container.encode(content, forKey: .content)
        try container.encode(source, forKey: .source)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(citations, forKey: .citations)
    }
}
