//
//  File.swift
//  
//
//  Created by Lou Zell on 10/12/24.
//

import Foundation

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
