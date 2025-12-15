//
//  AnthropicWebSearchResultBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// A web search result item.
nonisolated public struct AnthropicWebSearchResultBlockParam: Encodable, Sendable {
    /// The encrypted content of the search result.
    public let encryptedContent: String

    /// The title of the search result.
    public let title: String

    /// The URL of the search result.
    public let url: String

    /// The age of the page (optional).
    public let pageAge: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case encryptedContent = "encrypted_content"
        case title
        case url
        case pageAge = "page_age"
    }

    public init(
        encryptedContent: String,
        title: String,
        url: String,
        pageAge: String? = nil
    ) {
        self.encryptedContent = encryptedContent
        self.title = title
        self.url = url
        self.pageAge = pageAge
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("web_search_result", forKey: .type)
        try container.encode(encryptedContent, forKey: .encryptedContent)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(pageAge, forKey: .pageAge)
    }
}
