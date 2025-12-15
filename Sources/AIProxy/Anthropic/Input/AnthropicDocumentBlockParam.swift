//
//  AnthropicDocumentBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// A document content block for PDFs, plain text, or structured content.
///
/// Represents Anthropic's `DocumentBlockParam` object:
/// https://console.anthropic.com/docs/en/api/messages#document_block_param
nonisolated public struct AnthropicDocumentBlockParam: Encodable, Sendable {
    /// The document source.
    public let source: AnthropicDocumentBlockParamSource

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// Configuration for enabling citations.
    public let citations: AnthropicCitationsConfigParam?

    /// Additional context about the document.
    public let context: String?

    /// The title of the document.
    public let title: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case source
        case cacheControl = "cache_control"
        case citations
        case context
        case title
    }

    public init(
        source: AnthropicDocumentBlockParamSource,
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        citations: AnthropicCitationsConfigParam? = nil,
        context: String? = nil,
        title: String? = nil
    ) {
        self.source = source
        self.cacheControl = cacheControl
        self.citations = citations
        self.context = context
        self.title = title
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("document", forKey: .type)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(citations, forKey: .citations)
        try container.encodeIfPresent(context, forKey: .context)
        try container.encodeIfPresent(title, forKey: .title)
    }
}
