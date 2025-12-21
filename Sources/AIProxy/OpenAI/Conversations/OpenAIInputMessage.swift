//
//  OpenAIInputMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

// TODO: Do we need EasyInputMessage at all? Seems like this one is more up to date.

/// A message input to the model with a role indicating instruction following hierarchy.
///
/// Instructions given with the `developer` or `system` role take precedence over instructions given with the `user` role.
nonisolated public struct OpenAIInputMessage: Encodable, Sendable {
    /// The type of the message input. Always set to `message`.
    public let type = "message"

    /// The content of the message.
    public let content: OpenAIInputMessageContentList

    /// The role of the message input.
    ///
    /// One of `user`, `system`, or `developer`.
    public let role: OpenAIRole

    /// The status of item.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when items are returned via API.
    public let status: Status?

    /// Creates a new input message.
    /// - Parameters:
    ///   - role: The role of the message input.
    ///   - content: The content of the message.
    ///   - status: The status of item.
    public init(
        content: InputMessageContentList,
        role: Role,
        status: Status? = nil
    ) {
        self.content = content
        self.role = role
        self.status = status
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case content
        case role
        case status
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(role, forKey: .role)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encode(content, forKey: .content)
    }
}

extension InputMessage {
    /// The status of the message item.
    nonisolated public enum Status: String, Encodable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
    }
}
