//
//  OpenAIConversation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ConversationResource, version 2.3.0, line 66269
// https://platform.openai.com/docs/api-reference/conversations/object

/// A conversation resource.
nonisolated public struct OpenAIConversation: Decodable, Sendable {
    /// The time at which the conversation was created, measured in seconds since the Unix epoch.
    public let createdAt: Int

    /// The unique ID of the conversation.
    public let id: String

    /// Set of 16 key-value pairs that can be attached to an object.
    ///
    /// This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.
    /// Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]

    /// The object type, which is always `conversation`.
    public let object = "conversation"

    /// Creates a new conversation resource.
    /// - Parameters:
    ///   - createdAt: The time at which the conversation was created, measured in seconds since the Unix epoch.
    ///   - id: The unique ID of the conversation.
    ///   - metadata: Set of 16 key-value pairs that can be attached to an object.
    ///   - object: The object type, which is always `conversation`.
    public init(
        createdAt: Int,
        id: String,
        metadata: [String: String]
    ) {
        self.createdAt = createdAt
        self.id = id
        self.metadata = metadata
    }

    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.metadata = try container.decode([String: String].self, forKey: .metadata)
    }
}
