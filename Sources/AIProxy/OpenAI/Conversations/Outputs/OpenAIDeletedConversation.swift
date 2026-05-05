//
//  OpenAIDeletedConversation.swift
//  AIProxy
//
//  Created by Lou Zell on 1/13/26.
//

import Foundation

/// Represents a deleted OpenAI Conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/delete
nonisolated public struct OpenAIDeletedConversation: Decodable, Sendable {
    /// Whether the conversation was successfully deleted.
    public let deleted: Bool

    /// The ID of the deleted conversation.
    public let id: String

    /// The object type, which is always `conversation.deleted`.
    public let object: String = "conversation.deleted"

    private enum CodingKeys: String, CodingKey {
        case deleted
        case id
    }
}
