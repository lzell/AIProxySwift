//
//  OpenAIInputFileContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: InputFileContent, version 2.3.0, line 65124
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-input_file

/// A file input to the model.
public nonisolated struct OpenAIInputFile: Codable, Sendable {
    /// The type of the input item. Always `input_file`.
    public let type = "input_file"

    /// The ID of the file to be sent to the model.
    public let fileID: String?

    /// The name of the file to be sent to the model.
    public let filename: String?

    /// The URL of the file to be sent to the model.
    public let fileURL: String?

    /// The content of the file to be sent to the model.
    public let fileData: String?

    /// Creates a new input file content.
    /// - Parameters:
    ///   - fileID: The ID of the file to be sent to the model.
    ///   - filename: The name of the file to be sent to the model.
    ///   - fileURL: The URL of the file to be sent to the model.
    ///   - fileData: The content of the file to be sent to the model.
    public init(
        fileID: String? = nil,
        filename: String? = nil,
        fileURL: String? = nil,
        fileData: String? = nil
    ) {
        self.fileID = fileID
        self.filename = filename
        self.fileURL = fileURL
        self.fileData = fileData
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case fileID = "file_id"
        case filename
        case fileURL = "file_url"
        case fileData = "file_data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fileID = try container.decodeIfPresent(String.self, forKey: .fileID)
        self.filename = try container.decodeIfPresent(String.self, forKey: .filename)
        self.fileURL = try container.decodeIfPresent(String.self, forKey: .fileURL)
        self.fileData = try container.decodeIfPresent(String.self, forKey: .fileData)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(fileID, forKey: .fileID)
        try container.encodeIfPresent(filename, forKey: .filename)
        try container.encodeIfPresent(fileURL, forKey: .fileURL)
        try container.encodeIfPresent(fileData, forKey: .fileData)
    }
}
