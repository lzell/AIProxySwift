//
//  OpenAIAnnotation.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: Annotation, version 2.3.0, line 64911
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text-annotations

/// An annotation in the output text.
nonisolated public enum OpenAIAnnotation: Codable, Sendable {
    case containerFileCitation(OpenAIContainerFileCitation)
    case fileCitation(OpenAIFileCitation)
    case filePath(OpenAIFilePath)
    case urlCitation(OpenAIURLCitation)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "container_file_citation":
            self = .containerFileCitation(try OpenAIContainerFileCitation(from: decoder))
        case "file_citation":
            self = .fileCitation(try OpenAIFileCitation(from: decoder))
        case "file_path":
            self = .filePath(try OpenAIFilePath(from: decoder))
        case "url_citation":
            self = .urlCitation(try OpenAIURLCitation(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown annotation type: \(type)"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .containerFileCitation(let annotation):
            try annotation.encode(to: encoder)
        case .fileCitation(let annotation):
            try annotation.encode(to: encoder)
        case .filePath(let annotation):
            try annotation.encode(to: encoder)
        case .urlCitation(let annotation):
            try annotation.encode(to: encoder)
        }
    }
}
