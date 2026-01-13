//
//  OpenAIConversationsResource.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Represents an OpenAI Conversation resource.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/object
nonisolated public struct OpenAIConversationsResource: Decodable, Sendable {
    /// The unique ID of the conversation.
    public let id: String

    /// The object type, which is always `conversation`.
    public let object: String

    /// Set of 16 key-value pairs that can be attached to an object.
    /// Keys are strings with a maximum length of 64 characters.
    /// Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]

    /// The time at which the conversation was created, measured in seconds since the Unix epoch.
    public let createdAt: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case object
        case metadata
        case createdAt = "created_at"
    }
}
