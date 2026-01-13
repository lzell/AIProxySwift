//
//  OpenAIConversationsUpdateRequestBody.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Request body for updating a conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/update
nonisolated public struct OpenAIConversationsUpdateRequestBody: Encodable, Sendable {

    /// Set of 16 key-value pairs that can be attached to an object.
    /// Keys are strings with a maximum length of 64 characters.
    /// Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]

    public init(
        metadata: [String: String]
    ) {
        self.metadata = metadata
    }
}
