//
//  OpenAIScrollAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A scroll action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-scroll
nonisolated public struct OpenAIScrollAction: Codable, Sendable {
    /// The horizontal scroll distance.
    public let scrollX: Int

    /// The vertical scroll distance.
    public let scrollY: Int

    /// Specifies the event type. For a scroll action, this property is always set to `scroll`.
    public let type = "scroll"

    /// The x-coordinate where the scroll occurred.
    public let x: Int

    /// The y-coordinate where the scroll occurred.
    public let y: Int

    /// Creates a new scroll action.
    /// - Parameters:
    ///   - scrollX: The horizontal scroll distance.
    ///   - scrollY: The vertical scroll distance.
    ///   - x: The x-coordinate where the scroll occurred.
    ///   - y: The y-coordinate where the scroll occurred.
    public init(
        scrollX: Int,
        scrollY: Int,
        x: Int,
        y: Int
    ) {
        self.scrollX = scrollX
        self.scrollY = scrollY
        self.x = x
        self.y = y
    }

    private enum CodingKeys: String, CodingKey {
        case scrollX = "scroll_x"
        case scrollY = "scroll_y"
        case type
        case x
        case y
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scrollX, forKey: .scrollX)
        try container.encode(scrollY, forKey: .scrollY)
        try container.encode(type, forKey: .type)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}
