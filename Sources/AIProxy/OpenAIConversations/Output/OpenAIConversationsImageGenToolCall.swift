//
//  OpenAIConversationsImageGenToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An image generation tool call item in a conversation.
nonisolated public struct OpenAIConversationsImageGenToolCall: Decodable, Sendable {
    /// The type of the item, always "image_generation_call".
    public let type: String

    /// The unique ID of the image generation call.
    public let id: String

    /// The status of the image generation call.
    public let status: String?

    /// The result of the image generation.
    public let result: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case result
    }
}
