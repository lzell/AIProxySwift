//
//  OpenAIContainerFileCitation.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: ContainerFileCitationBody, version 2.3.0, line 64877
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-annotations-container_file_citation

/// A citation for a container file used to generate a model response.
nonisolated public struct OpenAIContainerFileCitation: Codable, Sendable {
    /// The ID of the container file.
    public let containerID: String

    /// The index of the last character of the container file citation in the message.
    public let endIndex: Int

    /// The ID of the file.
    public let fileID: String

    /// The filename of the container file cited.
    public let filename: String

    /// The index of the first character of the container file citation in the message.
    public let startIndex: Int

    /// The type of the container file citation. Always `container_file_citation`.
    public let type = "container_file_citation"

    /// Creates a new container file citation.
    /// - Parameters:
    ///   - containerID: The ID of the container file.
    ///   - endIndex: The index of the last character of the container file citation in the message.
    ///   - fileID: The ID of the file.
    ///   - filename: The filename of the container file cited.
    ///   - startIndex: The index of the first character of the container file citation in the message.
    public init(
        containerID: String,
        endIndex: Int,
        fileID: String,
        filename: String,
        startIndex: Int
    ) {
        self.containerID = containerID
        self.endIndex = endIndex
        self.fileID = fileID
        self.filename = filename
        self.startIndex = startIndex
    }

    private enum CodingKeys: String, CodingKey {
        case containerID = "container_id"
        case endIndex = "end_index"
        case fileID = "file_id"
        case filename
        case startIndex = "start_index"
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.containerID = try container.decode(String.self, forKey: .containerID)
        self.endIndex = try container.decode(Int.self, forKey: .endIndex)
        self.fileID = try container.decode(String.self, forKey: .fileID)
        self.filename = try container.decode(String.self, forKey: .filename)
        self.startIndex = try container.decode(Int.self, forKey: .startIndex)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(containerID, forKey: .containerID)
        try container.encode(endIndex, forKey: .endIndex)
        try container.encode(fileID, forKey: .fileID)
        try container.encode(filename, forKey: .filename)
        try container.encode(startIndex, forKey: .startIndex)
        try container.encode(type, forKey: .type)
    }
}
