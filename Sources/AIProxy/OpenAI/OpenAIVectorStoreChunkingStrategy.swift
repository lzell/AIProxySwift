//
//  OpenAIVectorStoreChunkingStrategy.swift
//  AIProxy
//
//  Created by Lou Zell on 7/7/25.
//

/// Strategy for chunking files when adding them to a vector store.
public enum OpenAIVectorStoreChunkingStrategy: Codable {
    /// The default strategy.
    /// This strategy currently uses a `max_chunk_size_tokens` of 800 and `chunk_overlap_tokens` of 400.
    case auto

    /// Customize your own chunking strategy by setting chunk size and chunk overlap
    ///
    /// - chunkOverlapTokens: The number of tokens that overlap between chunks. The default value is 400.
    ///                   Note that the overlap must not exceed half of `max_chunk_size_tokens`
    ///
    /// - maxChunkSizeTokens: The maximum number of tokens in each chunk.
    ///                    The default value is 800.
    ///                    The minimum value is 100 and the maximum value is 4096.
    case `static`(chunkOverlapTokens: Int, maxChunkSizeTokens: Int)

    private enum CodingKeys: String, CodingKey {
        case type
        case `static`
    }

    private enum NestedKeys: String, CodingKey {
        case chunkOverlapTokens = "chunk_overlap_tokens"
        case maxChunkSizeTokens = "max_chunk_size_tokens"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .auto:
            try container.encode("auto", forKey: .type)
        case .static(let chunkOverlapTokens, let maxChunkSizeTokens):
            try container.encode("static", forKey: .type)
            var nested = container.nestedContainer(keyedBy: NestedKeys.self, forKey: .static)
            try nested.encode(chunkOverlapTokens, forKey: .chunkOverlapTokens)
            try nested.encode(maxChunkSizeTokens, forKey: .maxChunkSizeTokens)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "auto":
            self = .auto
        case "static":
            let nested = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .static)
            let chunkOverlapTokens = try nested.decode(Int.self, forKey: .chunkOverlapTokens)
            let maxChunkSizeTokens = try nested.decode(Int.self, forKey: .maxChunkSizeTokens)
            self = .static(chunkOverlapTokens: chunkOverlapTokens, maxChunkSizeTokens: maxChunkSizeTokens)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown chunking strategy type: \(type)")
        }
    }
}
