//
//  OpenAIMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: Message, version 2.3.0, line 65153

/// A message to or from the model.
nonisolated public struct OpenAIMessageResource: Decodable, Sendable {
    /// The content of the message
    public let content: [OpenAIMessageContent]

    /// The unique ID of the message.
    public let id: String

    /// The role of the message.
    ///
    /// One of `unknown`, `user`, `assistant`, `system`, `critic`, `discriminator`, `developer`, or `tool`.
    public let role: OpenAIMessageRole

    /// The status of item.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when items are returned via API.
    public let status: OpenAIMessageStatus

    /// The type of the message. Always set to `message`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case content
        case id
        case role
        case status
        case type
    }
}

/// The role of the message.
nonisolated public enum OpenAIMessageRole: String, Decodable, Sendable {
    case assistant
    case critic
    case developer
    case discriminator
    case system
    case tool
    case unknown
    case user
}

/// The status of the message.
nonisolated public enum OpenAIMessageStatus: String, Decodable, Sendable {
    case completed
    case inProgress = "in_progress"
    case incomplete
}
