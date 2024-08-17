//
//  OpenAIChatCompletionResponseBody.swift
//
//
//  Created by Lou Zell on 8/17/24.
//

import Foundation

public struct OpenAIChatCompletionResponseBody: Decodable {
    public let model: String
    public let choices: [OpenAIChatChoice]
}

public struct OpenAIChatChoice: Decodable {
    public let message: OpenAIChoiceMessage
    public let finishReason: String

    private enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

public struct OpenAIChoiceMessage: Decodable {
    public let role: String
    public let content: String
}
