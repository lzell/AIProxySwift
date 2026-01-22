//
//  OpenAIClickAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//


/// A click action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-click
nonisolated public struct OpenAIClickAction: Codable, Sendable {
    /// Indicates which mouse button was pressed during the click.
    ///
    /// One of `left`, `right`, `wheel`, `back`, or `forward`.
    public let button: Button

    /// Specifies the event type. For a click action, this property is always `click`.
    public let type = "click"

    /// The x-coordinate where the click occurred.
    public let x: Int

    /// The y-coordinate where the click occurred.
    public let y: Int

    /// Creates a new click action.
    /// - Parameters:
    ///   - button: Indicates which mouse button was pressed during the click.
    ///   - x: The x-coordinate where the click occurred.
    ///   - y: The y-coordinate where the click occurred.
    public init(
        button: Button,
        x: Int,
        y: Int
    ) {
        self.button = button
        self.x = x
        self.y = y
    }

    private enum CodingKeys: String, CodingKey {
        case button
        case type
        case x
        case y
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(button, forKey: .button)
        try container.encode(type, forKey: .type)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

extension OpenAIClickAction {
    nonisolated public enum Button: String, Codable, Sendable {
        case left
        case right
        case wheel
        case back
        case forward
    }
}
