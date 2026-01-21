//
//  OpenAIReasoningSummaryText.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public struct OpenAIReasoningSummaryText: Codable, Sendable {
    /// A summary of the reasoning output from the model so far.
    public let text: String

    /// The type of the object. Always `summary_text`.
    public let type = "summary_text"

    public init(text: String) {
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }
}
