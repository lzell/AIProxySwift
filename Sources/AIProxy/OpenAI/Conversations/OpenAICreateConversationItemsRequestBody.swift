//
//  OpenAICreateConversationItemsRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//

import Foundation

/// Request body for creating items in a conversation.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/create-items
nonisolated public struct OpenAICreateConversationItemsRequestBody: Encodable, Sendable {

    /// Items to add to the conversation.
    /// You may add up to 20 items at a time.
    public let items: [OpenAIInputItem]

    public init(items: [OpenAIInputItem]) {
        self.items = items
    }
}
