//
//  OpenAITypeAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// An action to type in text.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-type
nonisolated public struct OpenAITypeAction: Codable, Sendable {
    /// The text to type.
    public let text: String

    /// Specifies the event type. For a type action, this property is always set to `type`.
    public let type = "type"

    /// Creates a new type action.
    /// - Parameters:
    ///   - text: The text to type.
    public init(text: String) {
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: CodingKeys.text)
        try container.encode(type, forKey: CodingKeys.type)
    }
}
