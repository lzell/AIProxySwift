//
//  OpenAIConversationsReasoningItem.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A reasoning item in a conversation.
nonisolated public struct OpenAIConversationsReasoningItem: Decodable, Sendable {
    /// The type of the item, always "reasoning".
    public let type: String

    /// The unique ID of the reasoning item.
    public let id: String

    /// The status of the reasoning.
    public let status: String?

    /// The encrypted content of the reasoning.
    public let encryptedContent: String?

    /// The summary of the reasoning.
    public let summary: [OpenAIConversationsReasoningSummary]?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case encryptedContent = "encrypted_content"
        case summary
    }
}

/// A summary part of reasoning.
nonisolated public struct OpenAIConversationsReasoningSummary: Decodable, Sendable {
    /// The type of summary.
    public let type: String?

    /// The text content of the summary.
    public let text: String?
}
