//
//  OpenAIFileSearchToolCallResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: FileSearchToolCall, version 2.3.0, line 8674

/// The results of a file search tool call.
///
/// See the [file search guide](https://platform.openai.com/docs/guides/tools-file-search) for more information.
nonisolated public struct OpenAIFileSearchToolCallResource: Decodable, Sendable {
    /// The unique ID of the file search tool call.
    public let id: String

    /// The queries used to search for files.
    public let queries: [String]

    /// The status of the file search tool call.
    ///
    /// One of `in_progress`, `searching`, `incomplete` or `failed`.
    public let status: OpenAIFileSearchToolCallStatus

    /// The type of the file search tool call. Always `file_search_call`.
    public let type: String

    /// The results of the file search tool call.
    public let results: [OpenAIFileSearchResult]?

    private enum CodingKeys: String, CodingKey {
        case id
        case queries
        case status
        case type
        case results
    }
}

/// The status of a file search tool call.
nonisolated public enum OpenAIFileSearchToolCallStatus: String, Decodable, Sendable {
    case completed
    case failed
    case inProgress = "in_progress"
    case incomplete
    case searching
}

/// A result from a file search.
nonisolated public struct OpenAIFileSearchResult: Decodable, Sendable {
    /// The unique ID of the file.
    public let fileID: String?

    /// The name of the file.
    public let filename: String?

    /// The relevance score of the file - a value between 0 and 1.
    public let score: Float?

    /// The text that was retrieved from the file.
    public let text: String?

    /// Set of key-value pairs that can be attached to an object.
    public let attributes: [String: OpenAIFileSearchAttributeValue]?

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case filename
        case score
        case text
        case attributes
    }
}

/// A value in file search attributes.
nonisolated public enum OpenAIFileSearchAttributeValue: Decodable, Sendable {
    case bool(Bool)
    case number(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let numberValue = try? container.decode(Double.self) {
            self = .number(numberValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                OpenAIFileSearchAttributeValue.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected Bool, Double, or String"
                )
            )
        }
    }
}
