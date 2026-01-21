//
//  OpenAIFileCitation.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: FileCitationBody, version 2.3.0, line 64821
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-annotations-file_citation

/// A citation to a file.
nonisolated public struct OpenAIFileCitation: Encodable, Sendable {
    /// The ID of the file.
    public let fileID: String

    /// The filename of the file cited.
    public let filename: String

    /// The index of the file in the list of files.
    public let index: Int

    /// The type of the file citation. Always `file_citation`.
    public let type = "file_citation"

    /// Creates a new file citation.
    /// - Parameters:
    ///   - fileID: The ID of the file.
    ///   - filename: The filename of the file cited.
    ///   - index: The index of the file in the list of files.
    public init(
        fileID: String,
        filename: String,
        index: Int
    ) {
        self.fileID = fileID
        self.filename = filename
        self.index = index
    }

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case filename
        case index
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileID, forKey: .fileID)
        try container.encode(filename, forKey: .filename)
        try container.encode(index, forKey: .index)
        try container.encode(type, forKey: .type)
    }
}
