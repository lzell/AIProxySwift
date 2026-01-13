//
//  OpenAIDragAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A drag action.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-drag
nonisolated public struct OpenAIDragAction: Codable, Sendable {
    /// An array of coordinates representing the path of the drag action.
    ///
    /// Coordinates will appear as an array of objects, e.g.:
    /// ```
    /// [
    ///   { x: 100, y: 200 },
    ///   { x: 200, y: 300 }
    /// ]
    /// ```
    public let path: [Coordinate]

    /// Specifies the event type. For a drag action, this property is always set to `drag`.
    public let type = "drag"

    /// Creates a new drag action.
    /// - Parameters:
    ///   - path: An array of coordinates representing the path of the drag action.
    public init(path: [OpenAIDragAction.Coordinate]) {
        self.path = path
    }

    private enum CodingKeys: String, CodingKey {
        case path
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIDragAction {
    /// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-action-drag-path
    nonisolated public struct Coordinate: Codable, Sendable {
        /// The x-coordinate.
        public let x: Int

        /// The y-coordinate.
        public let y: Int

        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
}
