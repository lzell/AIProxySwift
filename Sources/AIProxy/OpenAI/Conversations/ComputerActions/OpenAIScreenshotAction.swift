//
//  OpenAIScreenshotAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A screenshot action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-screenshot
nonisolated public struct OpenAIScreenshotAction: Codable, Sendable {
    /// Specifies the event type. For a screenshot action, this property is always set to `screenshot`.
    public let type = "screenshot"

    /// Creates a new screenshot action.
    public init() {}

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}
