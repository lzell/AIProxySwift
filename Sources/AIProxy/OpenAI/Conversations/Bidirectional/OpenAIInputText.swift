//
//  OpenAIInputText.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: InputTextContent, version 2.3.0, line 64803
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-input_text

/// A text input to the model.
nonisolated public struct OpenAIInputText: Codable, Sendable {
    /// The type of the input item. Always `input_text`.
    public let type = "input_text"

    /// The text input to the model.
    public let text: String

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

extension OpenAIInputText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(text: value)
    }
}
