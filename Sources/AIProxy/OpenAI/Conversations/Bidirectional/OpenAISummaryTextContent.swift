//
//  OpenAISummaryTextContentResource.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: SummaryTextContent, version 2.3.0, line 65003
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-summary_text

/// A summary text from the model.
nonisolated public struct OpenAISummaryText: Codable, Sendable {
    /// A summary of the reasoning output from the model so far.
    public let text: String

    /// The type of the object. Always `summary_text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}
