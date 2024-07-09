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
    // Required
    public let model: String
    public let messages: [OpenAIChatMessage]

    // Optional
    public let responseFormat: OpenAIChatResponseFormat?
    public var stream: Bool?
    public var streamOptions: OpenAIChatStreamOptions?

    enum CodingKeys: String, CodingKey {
        case messages
        case model
        case responseFormat = "response_format"
        case stream
        case streamOptions = "stream_options"
    }

    public init(
        model: String,
        messages: [OpenAIChatMessage],
        responseFormat: OpenAIChatResponseFormat? = nil,
        stream: Bool? = nil,
        streamOptions: OpenAIChatStreamOptions? = nil
    ) {
        self.messages = messages
        self.model = model
        self.responseFormat = responseFormat
        self.stream = stream
        self.streamOptions = streamOptions
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

public enum OpenAIChatResponseFormat: Encodable {
    case type(String)

    enum CodingKeys: String, CodingKey {
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .type(let format):
            try container.encode(format, forKey: .type)
        }
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

public struct OpenAIChatStreamOptions: Encodable {
   /// If set, an additional chunk will be streamed before the data: [DONE] message.
   /// The usage field on this chunk shows the token usage statistics for the entire request,
   /// and the choices field will always be an empty array. All other chunks will also include
   /// a usage field, but with a null value.
   let includeUsage: Bool

   enum CodingKeys: String, CodingKey {
       case includeUsage = "include_usage"
   }
}


private struct OpenAIImageURL: Encodable {
    let url: URL
}


// MARK: - Response Codables
// MARK: Non-streaming
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


// MARK: Streaming
public struct OpenAIChatCompletionChunk: Codable {
    public let choices: [OpenAIChunkChoice]
}

public struct OpenAIChunkChoice: Codable {
    public let delta: OpenAIChunkDelta
    public let finishReason: String?

    enum CodingKeys: String, CodingKey {
        case delta
        case finishReason = "finish_reason"
    }
}

public struct OpenAIChunkDelta: Codable {
    public let role: String?
    public let content: String?
}


// MARK: - Internal extensions
extension OpenAIChatCompletionChunk {
    /// Creates a ChatCompletionChunk from a streamed line of the /v1/chat/completions response
    static func from(line: String) -> Self? {
        guard line.hasPrefix("data: ") else {
            aiproxyLogger.warning("Received unexpected line from aiproxy: \(line)")
            return nil
        }

        guard line != "data: [DONE]" else {
            aiproxyLogger.debug("Streaming response has finished")
            return nil
        }

        guard let chunkJSON = line.dropFirst(6).data(using: .utf8),
              let chunk = try? JSONDecoder().decode(OpenAIChatCompletionChunk.self, from: chunkJSON) else
        {
            aiproxyLogger.warning("Received unexpected JSON from aiproxy: \(line)")
            return nil
        }

        // aiproxyLogger.debug("Received a chunk: \(line)")
        return chunk
    }
}
