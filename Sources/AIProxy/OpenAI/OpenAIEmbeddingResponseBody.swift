//
//  OpenAIEmbeddingResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 2/16/25.
//

public struct OpenAIEmbeddingResponseBody: Decodable {
    public let embeddings: [Embedding]
    public let model: String?
    public let usage: Usage?

    private enum CodingKeys: CodingKey {
        case data
        case model
        case usage
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.embeddings = try container.decode([Embedding].self, forKey: .data)
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.usage = try container.decodeIfPresent(Usage.self, forKey: .usage)
    }
}

extension OpenAIEmbeddingResponseBody {
    public struct Embedding: Decodable {
        public let vector: [Double]
        public let index: Int?

        private enum CodingKeys: CodingKey {
            case embedding
            case index
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.vector = try container.decode([Double].self, forKey: .embedding)
            self.index = try container.decodeIfPresent(Int.self, forKey: .index)
        }
    }
}

extension OpenAIEmbeddingResponseBody {
    public struct Usage: Decodable {
        public let promptTokens: Int
        public let totalTokens: Int

        private enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
}
