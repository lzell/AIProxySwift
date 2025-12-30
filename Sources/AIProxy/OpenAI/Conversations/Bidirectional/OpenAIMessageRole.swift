//
//  OpenAIMessageRole.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/25.
//
// OpenAPI spec: MessageRole, version 2.3.0, line 64792
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-role

/// The role of the message.
nonisolated public enum OpenAIMessageRole: String, Codable, Sendable {
    case assistant
    case critic
    case developer
    case discriminator
    case system
    case tool
    case unknown
    case user
}
