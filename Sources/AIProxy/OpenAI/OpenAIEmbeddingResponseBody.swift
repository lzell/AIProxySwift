//
//  OpenAIEmbeddingResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 2/16/25.
//

/// https://platform.openai.com/docs/api-reference/embeddings/object
nonisolated public struct OpenAIEmbeddingResponseBody: Decodable, Sendable {
    public let embeddings: [Embedding]
    public let model: String?
    public let usage: Usage?

    public init(embeddings: [Embedding], model: String?, usage: Usage?) {
        self.embeddings = embeddings
        self.model = model
        self.usage = usage
    }

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

// MARK: -
extension OpenAIEmbeddingResponseBody {
    nonisolated public struct Embedding: Decodable, Sendable {
        public let vector: [Double]
        public let index: Int?

        public init(vector: [Double], index: Int?) {
            self.vector = vector
            self.index = index
        }

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

// MARK: -
extension OpenAIEmbeddingResponseBody {
    nonisolated public struct Usage: Decodable, Sendable {
        public let promptTokens: Int
        public let totalTokens: Int

        public init(promptTokens: Int, totalTokens: Int) {
            self.promptTokens = promptTokens
            self.totalTokens = totalTokens
        }

        private enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
}
