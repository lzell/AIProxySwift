//
//  OpenAIFilePath.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: FilePath, version 2.3.0, line 42341
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-annotations-file_path

/// A path to a file.
nonisolated public struct OpenAIFilePath: Codable, Sendable {
    /// The ID of the file.
    public let fileID: String

    /// The index of the file in the list of files.
    public let index: Int

    /// The type of the file path. Always `file_path`.
    public let type = "file_path"

    /// Creates a new file path.
    /// - Parameters:
    ///   - fileID: The ID of the file.
    ///   - index: The index of the file in the list of files.
    public init(
        fileID: String,
        index: Int
    ) {
        self.fileID = fileID
        self.index = index
    }

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case index
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fileID = try container.decode(String.self, forKey: .fileID)
        self.index = try container.decode(Int.self, forKey: .index)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileID, forKey: .fileID)
        try container.encode(index, forKey: .index)
        try container.encode(type, forKey: .type)
    }
}
