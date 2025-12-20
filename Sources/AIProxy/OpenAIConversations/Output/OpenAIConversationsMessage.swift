//
//  OpenAIConversationsMessage.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A message item in a conversation.
nonisolated public struct OpenAIConversationsMessage: Decodable, Sendable {
    /// The type of the item, always "message".
    public let type: String

    /// The unique ID of the message.
    public let id: String

    /// The status of the message.
    public let status: String?

    /// The role of the message author (user, assistant, system).
    public let role: String?

    /// The content of the message.
    public let content: [OpenAIConversationsContentPart]?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case role
        case content
    }
}

/// A content part within a message.
nonisolated public enum OpenAIConversationsContentPart: Decodable, Sendable {
    case text(OpenAIConversationsTextContent)
    case refusal(OpenAIConversationsRefusalContent)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "output_text", "input_text", "text":
            self = .text(try OpenAIConversationsTextContent(from: decoder))
        case "refusal":
            self = .refusal(try OpenAIConversationsRefusalContent(from: decoder))
        default:
            self = .futureProof
        }
    }
}

/// Text content in a message.
nonisolated public struct OpenAIConversationsTextContent: Decodable, Sendable {
    public let type: String
    public let text: String
}

/// Refusal content in a message.
nonisolated public struct OpenAIConversationsRefusalContent: Decodable, Sendable {
    public let type: String
    public let refusal: String
}
