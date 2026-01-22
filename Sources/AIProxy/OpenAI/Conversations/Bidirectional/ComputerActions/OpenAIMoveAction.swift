//
//  OpenAIMoveAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A mouse move action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-move
nonisolated public struct OpenAIMoveAction: Codable, Sendable {
    /// Specifies the event type. For a move action, this property is always set to `move`.
    public let type = "move"

    /// The x-coordinate to move to.
    public let x: Int

    /// The y-coordinate to move to.
    public let y: Int

    /// Creates a new mouse move action.
    /// - Parameters:
    ///   - x: The x-coordinate to move to.
    ///   - y: The y-coordinate to move to.
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
