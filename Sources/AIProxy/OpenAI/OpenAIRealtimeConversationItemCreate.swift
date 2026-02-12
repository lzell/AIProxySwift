//
//  OpenAIRealtimeConversationItemCreate.swift
//
//
//  Created by Lou Zell on 10/12/24.
//

import Foundation

/// https://platform.openai.com/docs/api-reference/realtime-client-events/conversation/item/create
nonisolated public struct OpenAIRealtimeConversationItemCreate: Encodable {
    public let type = "conversation.item.create"
    public let item: Item

    public init(item: Item) {
        self.item = item
    }
}

// MARK: -
public extension OpenAIRealtimeConversationItemCreate {
    struct Item: Encodable {
        public let type = "message"
        public let role: String
        public let content: [Content]

        public init(role: String, text: String) {
            self.role = role
            // The OpenAI Realtime API requires different content types per role:
            //   - user/system: "input_text"
            //   - assistant: "text"
            // See: https://platform.openai.com/docs/api-reference/realtime-client-events/conversation/item/create
            let contentType = (role == "assistant") ? "text" : "input_text"
            self.content = [Content(type: contentType, text: text)]
        }
    }
}

// MARK: -
public extension OpenAIRealtimeConversationItemCreate.Item {
    struct Content: Encodable {
        public let type: String
        public let text: String

        public init(type: String = "input_text", text: String) {
            self.type = type
            self.text = text
        }
    }
}
