//
//  OpenAIConversationsDeletedResource.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Represents a deleted OpenAI Conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/delete
nonisolated public struct OpenAIConversationsDeletedResource: Decodable, Sendable {
    /// The object type, which is always `conversation.deleted`.
    public let object: String

    /// Whether the conversation was successfully deleted.
    public let deleted: Bool

    /// The ID of the deleted conversation.
    public let id: String
}
