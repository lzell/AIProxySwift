//
//  File.swift
//  
//
//  Created by Lou Zell on 10/12/24.
//

import Foundation

public struct OpenAIRealtimeConversationItemCreate: Encodable {
    public let type = "conversation.item.create"
    public let item: Item
}
public extension OpenAIRealtimeConversationItemCreate {
    struct Item: Encodable {
        let type = "message"
        let role: String
        let content: [Content]
    }
}
public extension OpenAIRealtimeConversationItemCreate.Item {
    struct Content: Encodable {
        let type = "input_text"
        let text: String
    }
}


// MARK: -
public struct OpenAIRealtimeResponseCreate: Encodable {
    public let type = "response.create"
    public let response: OpenAIRealtimeInnerResponse?

    internal init(response: OpenAIRealtimeInnerResponse?) {
        self.response = response
    }
}

public struct OpenAIRealtimeInnerResponse: Encodable {
    internal init(modalities: [String], instructions: String) {
        self.modalities = modalities
        self.instructions = instructions
    }
    
    public let modalities: [String]
    public let instructions: String
}
