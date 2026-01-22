//
//  OpenAIReasoningText.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: ReasoningTextContent, version 2.3.0, line 65021
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-reasoning_text

nonisolated public struct OpenAIReasoningText: Codable, Sendable {
    /// The reasoning text from the model.
    public let text: String

    /// The type of the reasoning text. Always `reasoning_text`.
    public let type = "reasoning_text"

    public init(text: String) {
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case text
    }
}
