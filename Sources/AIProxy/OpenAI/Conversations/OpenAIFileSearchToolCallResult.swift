//
//  Result.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A file search result.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-file_search_tool_call-results
public nonisolated struct OpenAIFileSearchToolCallResult: Encodable, Sendable {
    /// Set of 16 key-value pairs that can be attached to an object. This can be
    /// useful for storing additional information about the object in a structured
    /// format, and querying for objects via API or the dashboard. Keys are strings
    /// with a maximum length of 64 characters. Values are strings with a maximum
    /// length of 512 characters, booleans, or numbers.
    public let attributes: [String: String]?

    /// The unique ID of the file.
    public let fileID: String?

    /// The name of the file.
    public let filename: String?

    /// The relevance score of the file - a value between 0 and 1.
    public let score: Float?

    /// The text that was retrieved from the file.
    public let text: String?


    /// Creates a new file search result.
    /// - Parameters:
    ///   - fileID: The unique ID of the file.
    ///   - filename: The name of the file.
    ///   - score: The relevance score of the file.
    ///   - text: The text that was retrieved from the file.
    ///   - attributes: Additional attributes of the vector store file.
    public init(
        attributes: [String: String]? = nil,
        fileID: String? = nil,
        filename: String? = nil,
        score: Float? = nil,
        text: String? = nil
    ) {
        self.attributes = attributes
        self.fileID = fileID
        self.filename = filename
        self.score = score
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case attributes
        case fileID = "file_id"
        case filename
        case score
        case text
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attributes, forKey: .attributes)
        try container.encodeIfPresent(fileID, forKey: .fileID)
        try container.encodeIfPresent(filename, forKey: .filename)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(text, forKey: .text)
    }
}
