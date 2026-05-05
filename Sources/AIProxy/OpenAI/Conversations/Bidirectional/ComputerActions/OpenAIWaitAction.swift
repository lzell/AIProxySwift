//
//  OpenAIWaitAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A wait action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-wait
nonisolated public struct OpenAIWaitAction: Codable, Sendable {
    /// Specifies the event type. For a wait action, this property is always set to `wait`.
    public let type = "wait"

    /// Creates a new wait action.
    public init() {}

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}
