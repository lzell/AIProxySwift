//
//  OpenAIAnnotation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: Annotation, version 2.3.0, line 64911

/// An annotation in the output text.
nonisolated public enum OpenAIAnnotation: Decodable, Sendable {
    case containerFileCitation(OpenAIContainerFileCitationResource)
    case fileCitation(OpenAIFileCitationResource)
    case filePath(OpenAIFilePathResource)
    case urlCitation(OpenAIURLCitationResource)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "container_file_citation":
            self = .containerFileCitation(try OpenAIContainerFileCitationResource(from: decoder))
        case "file_citation":
            self = .fileCitation(try OpenAIFileCitationResource(from: decoder))
        case "file_path":
            self = .filePath(try OpenAIFilePathResource(from: decoder))
        case "url_citation":
            self = .urlCitation(try OpenAIURLCitationResource(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown annotation type: \(type)"
            )
        }
    }
}

// MARK: - File Citation

/// A citation to a file.
nonisolated public struct OpenAIFileCitationResource: Decodable, Sendable {
    /// The ID of the file.
    public let fileID: String

    /// The filename of the file cited.
    public let filename: String

    /// The index of the file in the list of files.
    public let index: Int

    /// The type of the file citation. Always `file_citation`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case filename
        case index
        case type
    }
}

// MARK: - URL Citation

/// A citation for a web resource used to generate a model response.
nonisolated public struct OpenAIURLCitationResource: Decodable, Sendable {
    /// The index of the last character of the URL citation in the message.
    public let endIndex: Int

    /// The index of the first character of the URL citation in the message.
    public let startIndex: Int

    /// The title of the web resource.
    public let title: String

    /// The type of the URL citation. Always `url_citation`.
    public let type: String

    /// The URL of the web resource.
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case endIndex = "end_index"
        case startIndex = "start_index"
        case title
        case type
        case url
    }
}

// MARK: - Container File Citation

64877 ContainerFileCitationBody
/// A citation for a container file used to generate a model response.
nonisolated public struct OpenAIContainerFileCitationResource: Decodable, Sendable {
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
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case containerID = "container_id"
        case endIndex = "end_index"
        case fileID = "file_id"
        case filename
        case startIndex = "start_index"
        case type
    }
}

// MARK: - File Path

/// A path to a file.
nonisolated public struct OpenAIFilePathResource: Decodable, Sendable {
    /// The ID of the file.
    public let fileID: String

    /// The index of the file in the list of files.
    public let index: Int

    /// The type of the file path. Always `file_path`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case index
        case type
    }
}

// MARK: - Log Probability

/// The log probability of a token.
nonisolated public struct OpenAILogProb: Decodable, Sendable {
    /// The bytes that were used to generate the log probability.
    public let bytes: [Int]

    /// The log probability of the token.
    public let logprob: Double

    /// The token that was used to generate the log probability.
    public let token: String

    /// Top log probabilities for alternative tokens.
    public let topLogprobs: [OpenAITopLogProb]

    private enum CodingKeys: String, CodingKey {
        case bytes
        case logprob
        case token
        case topLogprobs = "top_logprobs"
    }
}

/// The top log probability of a token.
nonisolated public struct OpenAITopLogProb: Decodable, Sendable {
    /// The bytes of the token.
    public let bytes: [Int]

    /// The log probability of the token.
    public let logprob: Double

    /// The token.
    public let token: String

    private enum CodingKeys: String, CodingKey {
        case bytes
        case logprob
        case token
    }
}
