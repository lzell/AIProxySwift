//
//  OpenAIURLCitation.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: UrlCitationBody, version 2.3.0, line 64847
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-annotations-url_citation

/// A citation for a web resource used to generate a model response.
nonisolated public struct OpenAIURLCitation: Codable, Sendable {
    /// The index of the first character of the URL citation in the message.
    public let startIndex: Int

    /// The index of the last character of the URL citation in the message.
    public let endIndex: Int

    /// The title of the web resource.
    public let title: String

    /// The type of the URL citation. Always `url_citation`.
    public let type = "url_citation"

    /// The URL of the web resource.
    public let url: String

    /// Creates a new URL citation.
    /// - Parameters:
    ///   - endIndex: The index of the last character of the URL citation in the message.
    ///   - startIndex: The index of the first character of the URL citation in the message.
    ///   - title: The title of the web resource.
    ///   - url: The URL of the web resource.
    public init(
        startIndex: Int,
        endIndex: Int,
        title: String,
        url: String
    ) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.title = title
        self.url = url
    }

    private enum CodingKeys: String, CodingKey {
        case endIndex = "end_index"
        case startIndex = "start_index"
        case title
        case type
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.endIndex = try container.decode(Int.self, forKey: .endIndex)
        self.startIndex = try container.decode(Int.self, forKey: .startIndex)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endIndex, forKey: .endIndex)
        try container.encode(startIndex, forKey: .startIndex)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}
