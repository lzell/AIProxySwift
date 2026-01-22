//
//  OpenAIOutputMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: OutputMessage, version 2.3.0, line 47200
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message

/// An output message from the model.
nonisolated public struct OpenAIOutputMessage: Encodable, Sendable {
    /// The content of the output message.
    public let content: [OpenAIOutputMessageContent]

    /// The unique ID of the output message.
    public let id: String

    /// The role of the output message. Always `assistant`.
    public let role = "assistant"

    /// The status of the message input.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when input items are returned via API.
    public let status: Status

    /// The type of the output message. Always `message`.
    public let type = "message"

    /// Creates a new output message.
    /// - Parameters:
    ///   - content: The content of the output message.
    ///   - id: The unique ID of the output message.
    ///   - status: The status of the message input.
    public init(
        content: [OpenAIOutputMessageContent],
        id: String,
        status: Status
    ) {
        self.content = content
        self.id = id
        self.status = status
    }

    private enum CodingKeys: String, CodingKey {
        case content
        case id
        case role
        case status
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(id, forKey: .id)
        try container.encode(role, forKey: .role)
        try container.encode(status, forKey: .status)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIOutputMessage {
    /// The status of the message.
    public enum Status: String, Encodable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
    }
}
