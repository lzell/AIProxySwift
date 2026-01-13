//
//  OpenAIConversationsFileSearchToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A file search tool call item in a conversation.
nonisolated public struct OpenAIConversationsFileSearchToolCall: Decodable, Sendable {
    /// The type of the item, always "file_search_call".
    public let type: String

    /// The unique ID of the file search call.
    public let id: String

    /// The status of the file search call.
    public let status: String?

    /// The queries used for file search.
    public let queries: [String]?

    /// The results of the file search.
    public let results: [OpenAIConversationsFileSearchResult]?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case queries
        case results
    }
}

/// A result from a file search.
nonisolated public struct OpenAIConversationsFileSearchResult: Decodable, Sendable {
    /// The ID of the file.
    public let fileId: String?

    /// The name of the file.
    public let fileName: String?

    /// The text content from the file.
    public let text: String?

    /// The relevance score.
    public let score: Double?

    private enum CodingKeys: String, CodingKey {
        case fileId = "file_id"
        case fileName = "file_name"
        case text
        case score
    }
}
