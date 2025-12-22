//
//  OpenAIFileSearchToolCall.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: FileSearchToolCall, version 2.3.0, line 42395
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-file_search_tool_call

/// The results of a file search tool call.
///
/// See the [file search guide](https://platform.openai.com/docs/guides/tools-file-search) for more information.
nonisolated public struct OpenAIFileSearchToolCall: Encodable, Sendable {
    /// The unique ID of the file search tool call.
    public let id: String

    /// The queries used to search for files.
    public let queries: [String]

    /// The status of the file search tool call.
    ///
    /// One of `in_progress`, `searching`, `incomplete` or `failed`.
    public let status: Status

    /// The type of the file search tool call. Always `file_search_call`.
    public let type = "file_search_call"

    /// The results of the file search tool call.
    public let results: [OpenAIFileSearchToolCallResult]?

    /// Creates a new file search tool call.
    /// - Parameters:
    ///   - id: The unique ID of the file search tool call.
    ///   - queries: The queries used to search for files.
    ///   - status: The status of the file search tool call.
    ///   - results: The results of the file search tool call.
    public init(
        id: String,
        queries: [String],
        status: Status,
        results: [Result]? = nil
    ) {
        self.id = id
        self.queries = queries
        self.status = status
        self.results = results
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case queries
        case status
        case type
        case results
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(queries, forKey: .queries)
        try container.encode(status, forKey: .status)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(results, forKey: .results)
    }
}

extension OpenAIFileSearchToolCall {
    /// The status of the file search tool call.
    nonisolated public enum Status: String, Encodable, Sendable {
        case inProgress = "in_progress"
        case searching
        case completed
        case incomplete
        case failed
    }
}
