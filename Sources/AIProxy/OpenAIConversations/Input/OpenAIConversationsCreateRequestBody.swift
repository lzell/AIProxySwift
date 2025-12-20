//
//  OpenAIConversationsCreateRequestBody.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Request body for creating a conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/create
nonisolated public struct OpenAIConversationsCreateRequestBody: Encodable, Sendable {

    /// Set of 16 key-value pairs that can be attached to an object.
    /// Keys are strings with a maximum length of 64 characters.
    /// Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]?

    /// Initial items to include in the conversation context.
    /// You may add up to 20 items at a time.
    public let items: [OpenAIConversationsInputItem]?

    public init(
        metadata: [String: String]? = nil,
        items: [OpenAIConversationsInputItem]? = nil
    ) {
        self.metadata = metadata
        self.items = items
    }
}
