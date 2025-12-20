//
//  OpenAIConversationsInputMessage.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An input message that can be added to a conversation.
nonisolated public struct OpenAIConversationsInputMessage: Encodable, Sendable {
    /// The type of item, always "message".
    public let type: String = "message"

    /// The role of the message author.
    public let role: OpenAIConversationsRole

    /// The content of the message.
    public let content: OpenAIConversationsInputContent

    public init(
        role: OpenAIConversationsRole,
        content: OpenAIConversationsInputContent
    ) {
        self.role = role
        self.content = content
    }
}

/// The role of a message author.
nonisolated public enum OpenAIConversationsRole: String, Encodable, Sendable {
    case user
    case assistant
    case system
}

/// The content of an input message.
nonisolated public enum OpenAIConversationsInputContent: Encodable, Sendable {
    case text(String)
    case parts([OpenAIConversationsInputContentPart])

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text):
            try container.encode(text)
        case .parts(let parts):
            try container.encode(parts)
        }
    }
}

/// A content part in an input message.
nonisolated public enum OpenAIConversationsInputContentPart: Encodable, Sendable {
    case text(OpenAIConversationsInputTextPart)
    case image(OpenAIConversationsInputImagePart)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let part):
            try part.encode(to: encoder)
        case .image(let part):
            try part.encode(to: encoder)
        }
    }
}

/// A text content part.
nonisolated public struct OpenAIConversationsInputTextPart: Encodable, Sendable {
    public let type: String = "input_text"
    public let text: String

    public init(text: String) {
        self.text = text
    }
}

/// An image content part.
nonisolated public struct OpenAIConversationsInputImagePart: Encodable, Sendable {
    public let type: String = "input_image"
    public let imageUrl: String?
    public let detail: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case imageUrl = "image_url"
        case detail
    }

    public init(
        imageUrl: String? = nil,
        detail: String? = nil
    ) {
        self.imageUrl = imageUrl
        self.detail = detail
    }
}

// MARK: - Convenience initializers

extension OpenAIConversationsInputMessage: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(role: .user, content: .text(value))
    }
}
