//
//  OpenAIRealtimeResponseCreate.swift
//
//
//  Created by Lou Zell on 10/14/24.
//

import Foundation

public struct OpenAIRealtimeResponseCreate: Encodable {
    public let type = "response.create"
    public let response: Response?

    internal init(response: Response? = nil) {
        self.response = response
    }
}

// MARK: - ResponseCreate.Response
public extension OpenAIRealtimeResponseCreate {

    struct Response: Encodable {
        public let instructions: String?
        public let modalities: [String]?

        public init(
            instructions: String? = nil,
            modalities: [String]? = nil
        ) {
            self.modalities = modalities
            self.instructions = instructions
        }
    }
}
