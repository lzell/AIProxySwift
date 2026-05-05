//
//  OpenAISearchAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Action type "search" - Performs a web search query.
nonisolated public struct OpenAISearchAction: Codable, Sendable {
    /// The search query.
    public let query: String

    /// The action type.
    public let type = "search"

    /// The sources used in the search.
    public let sources: [Source]?

    /// Creates a new search action.
    /// - Parameters:
    ///   - query: The search query.
    ///   - sources: The sources used in the search.
    public init(
        query: String,
        sources: [Source]? = nil
    ) {
        self.query = query
        self.sources = sources
    }

    private enum CodingKeys: String, CodingKey {
        case query
        case type
        case sources
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(sources, forKey: .sources)
    }
}

extension OpenAISearchAction {
    /// A source used in the search.
    nonisolated public struct Source: Codable, Sendable {
        /// The type of source. Always `url`.
        public let type = "url"

        /// The URL of the source.
        public let url: String

        /// Creates a new web search source.
        /// - Parameters:
        ///   - url: The URL of the source.
        public init(url: String) {
            self.url = url
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case url
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            try container.encode(url, forKey: .url)
        }
    }
}
