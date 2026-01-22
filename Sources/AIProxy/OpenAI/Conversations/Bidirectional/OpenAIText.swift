//
//  OpenAIText.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: TextContent, version 2.3.0, line 64987
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-text_content

nonisolated public struct OpenAIText: Codable, Sendable {
    /// The text.
    public let text: String

    /// The type of the content. Always `text`.
    public let type = "text"

    public init(text: String) {
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(text: value)
    }
}
