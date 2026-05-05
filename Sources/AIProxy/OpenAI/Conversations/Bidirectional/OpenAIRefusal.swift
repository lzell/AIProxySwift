//
//  OpenAIRefusalContent.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: RefusalContent, version 2.3.0
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content-refusal
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content-refusal

/// A refusal from the model.
nonisolated public struct OpenAIRefusal: Codable, Sendable {
    /// The refusal explanation from the model.
    public let refusal: String

    /// The type of the refusal. Always `refusal`.
    public let type = "refusal"

    /// Creates a new refusal content.
    /// - Parameters:
    ///   - refusal: The refusal explanation from the model.
    public init(refusal: String) {
        self.refusal = refusal
    }

    private enum CodingKeys: String, CodingKey {
        case refusal
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.refusal = try container.decode(String.self, forKey: .refusal)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(refusal, forKey: .refusal)
        try container.encode(type, forKey: .type)
    }
}
