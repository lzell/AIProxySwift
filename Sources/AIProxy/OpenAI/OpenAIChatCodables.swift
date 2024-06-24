//
//  OpenAIChatCodables.swift
//
//
//  Created by Lou Zell on 6/11/24.
//

import Foundation

// MARK: - Request Codables

/// Chat completion request body. See the OpenAI reference for available fields.
/// Contributions are welcome if you need something beyond the simple fields I've added so far.
public struct OpenAIChatCompletionRequestBody: Encodable {
    public let model: String
    public let messages: [OpenAIChatMessage]

    public init(model: String, messages: [OpenAIChatMessage]) {
        self.model = model
        self.messages = messages
    }
}

public struct OpenAIChatMessage: Encodable {
    public let role: String
    public let content: OpenAIChatContent

    public init(role: String, content: OpenAIChatContent) {
        self.role = role
        self.content = content
    }
}

/// ChatContent is made up of either a single piece of text or a collection of ChatContentParts
public enum OpenAIChatContent: Encodable {
    case text(String)
    case parts([OpenAIChatContentPart])

    public func encode(to encoder: Encoder) throws {
       var container = encoder.singleValueContainer()
       switch self {
       case .text(let text):
          try container.encode(text)
       case .parts(let contentParts):
          try container.encode(contentParts)
       }
    }
}

public enum OpenAIChatContentPart: Encodable {

    case text(String)
    case imageURL(URL)

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageURL = "image_url"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode("text", forKey: .type)
            try container.encode(text, forKey: .text)
        case .imageURL(let url):
            try container.encode("image_url", forKey: .type)
            try container.encode(OpenAIImageURL(url: url), forKey: .imageURL)
        }
    }
}

private struct OpenAIImageURL: Encodable {
    let url: URL
}


// MARK: - Response Codables
public struct OpenAIChatCompletionResponseBody: Decodable {
    public let model: String
    public let choices: [OpenAIChatChoice]
}

public struct OpenAIChatChoice: Decodable {
    public let message: OpenAIChoiceMessage
    public let finishReason: String

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

public struct OpenAIChoiceMessage: Decodable {
    public let role: String
    public let content: String
}
