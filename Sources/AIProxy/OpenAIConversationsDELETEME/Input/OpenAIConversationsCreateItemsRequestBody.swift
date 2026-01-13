//
//  OpenAIConversationsCreateItemsRequestBody.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Request body for creating items in a conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/create-items
nonisolated public struct OpenAIConversationsCreateItemsRequestBody: Encodable, Sendable {

    /// Items to add to the conversation.
    /// You may add up to 20 items at a time.
    public let items: [OpenAIConversationsInputItem]

    public init(
        items: [OpenAIConversationsInputItem]
    ) {
        self.items = items
    }
}
