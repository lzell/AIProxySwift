//
//  File.swift
//  
//
//  Created by Lou Zell on 10/12/24.
//

import Foundation

//{
//  "event_id": "evt_Rbb992kLkdDdLWmEc",
//  "type": "conversation.item.create",
//  "item": {
//    "type": "message",
//    "role": "user",
//    "content": [
//      {
//        "type": "input_text",
//        "text": "Hello!"
//      }
//    ]
//  }
//}


public struct OpenAIRealtimeConversationItemCreate: Encodable {
    public let type = "conversation.item.create"
    public let item: Item
}

// MARK: - ConversationItemCreate.Item
public extension OpenAIRealtimeConversationItemCreate {
    struct Item: Encodable {
        let type = "message"
        let role: String
        let content: [Content]
    }
}

// MARK: - ConversationItemCreate.Item.Content
public extension OpenAIRealtimeConversationItemCreate.Item {
    struct Content: Encodable {
        let type = "input_text"
        let text: String
    }
}
