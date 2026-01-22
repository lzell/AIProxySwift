//
//  OpenAIKeyPressAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A collection of keypresses the model would like to perform.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-keypress
nonisolated public struct OpenAIKeyPressAction: Codable, Sendable {
    /// The combination of keys the model is requesting to be pressed.
    /// Each element of the array represents a key.
    public let keys: [String]

    /// Specifies the event type. For a keypress action, this property is always set to `keypress`.
    public let type = "keypress"

    /// Creates a new keypress action.
    /// - Parameters:
    ///   - keys: The combination of keys the model is requesting to be pressed.
    public init(keys: [String]) {
        self.keys = keys
    }

    private enum CodingKeys: String, CodingKey {
        case keys
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keys, forKey: .keys)
        try container.encode(type, forKey: .type)
    }
}
