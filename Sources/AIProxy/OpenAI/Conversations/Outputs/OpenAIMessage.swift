//
//  OpenAIMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: Message, version 2.3.0, line 65153
// https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message

/// A message that is returned as part of the conversation item list.
/// The message may have originated from OpenAI or from the client.
nonisolated public struct OpenAIMessage: Decodable, Sendable {
    /// The content of the message
    public let content: [OpenAIMessageContent]

    /// The unique ID of the message.
    public let id: String

    /// The role of the message.
    public let role: Role

    /// The status of item.
    public let status: Status

    /// The type of the message. Always set to `message`.
    public let type = "message"

    private enum CodingKeys: String, CodingKey {
        case content
        case id
        case role
        case status
    }
}

extension OpenAIMessage {
    // OpenAPI spec: MessageRole, version 2.3.0, line 64792
    // Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-role
    /// The role of the message
    nonisolated public enum Role: String, Decodable, Sendable {
        case assistant
        case critic
        case developer
        case discriminator
        case system
        case tool
        case unknown
        case user
    }

    // OpenAPI spec: MessageStatus, version 2.3.0, line 64786
    // Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-status
    nonisolated public enum Status: String, Decodable, Sendable {
        case completed
        case inProgress = "in_progress"
        case incomplete
    }
}
