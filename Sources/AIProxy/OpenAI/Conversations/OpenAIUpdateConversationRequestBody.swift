//
//  OpenAIUpdateConversationRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 1/14/26.
//

import Foundation

/// Request body for updating a conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/update
nonisolated public struct OpenAIUpdateConversationRequestBody: Encodable, Sendable {

    /// Set of 16 key-value pairs that can be attached to an object.
    /// This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.
    /// Keys are strings with a maximum length of 64 characters.
    /// Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]

    public init(metadata: [String: String]) {
        self.metadata = metadata
    }
}
