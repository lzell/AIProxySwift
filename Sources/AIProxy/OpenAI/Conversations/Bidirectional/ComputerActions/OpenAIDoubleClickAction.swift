//
//  OpenAIDoubleClickAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A double click action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-doubleclick
nonisolated public struct OpenAIDoubleClickAction: Codable, Sendable {
    /// Specifies the event type. For a double click action, this property is always set to `double_click`.
    public let type = "double_click"

    /// The x-coordinate where the double click occurred.
    public let x: Int

    /// The y-coordinate where the double click occurred.
    public let y: Int

    /// Creates a new double click action.
    /// - Parameters:
    ///   - x: The x-coordinate where the double click occurred.
    ///   - y: The y-coordinate where the double click occurred.
    public init(
        x: Int,
        y: Int
    ) {
        self.x = x
        self.y = y
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case x
        case y
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}
