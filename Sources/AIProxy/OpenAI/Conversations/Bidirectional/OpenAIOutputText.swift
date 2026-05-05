//
//  OpenAIOutputText.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: OutputTextContent, version 2.3.0, line 64958
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-output_text
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-output_text

/// A text output from the model.
nonisolated public struct OpenAIOutputText: Codable, Sendable {
    /// The annotations of the text output.
    public let annotations: [OpenAIAnnotation]

    /// Log probabilities for tokens.
    public let logprobs: [OpenAILogprob]

    /// The text output from the model.
    public let text: String

    /// The type of the output text. Always `output_text`.
    public let type = "output_text"

    /// Creates a new output text content.
    /// - Parameters:
    ///   - annotations: The annotations of the text output.
    ///   - text: The text output from the model.
    ///   - logprobs: Log probabilities for tokens.
    public init(
        annotations: [OpenAIAnnotation],
        logprobs: [OpenAILogprob],
        text: String
    ) {
        self.annotations = annotations
        self.text = text
        self.logprobs = logprobs
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.annotations = try container.decode([OpenAIAnnotation].self, forKey: .annotations)
        self.logprobs = try container.decode([OpenAILogprob].self, forKey: .logprobs)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(annotations, forKey: .annotations)
        try container.encode(logprobs, forKey: .logprobs)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }

    private enum CodingKeys: String, CodingKey {
        case annotations
        case logprobs
        case text
        case type
    }
}
