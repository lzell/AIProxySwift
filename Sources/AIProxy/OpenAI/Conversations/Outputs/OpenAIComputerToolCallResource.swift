//
//  OpenAIComputerToolCallResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ComputerToolCall, version 2.3.0, line 2118

/// A tool call to a computer use tool.
///
/// See the [computer use guide](https://platform.openai.com/docs/guides/tools-computer-use) for more information.
nonisolated public struct OpenAIComputerToolCallResource: Decodable, Sendable {
    /// The computer action to perform.
    public let action: OpenAIComputerActionResource

    /// An identifier used when responding to the tool call with output.
    public let callID: String

    /// The unique ID of the computer call.
    public let id: String

    /// The pending safety checks for the computer call.
    public let pendingSafetyChecks: [OpenAIComputerSafetyCheckResource]

    /// The status of the item.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when items are returned via API.
    public let status: OpenAIComputerToolCallStatus

    /// The type of the computer call. Always `computer_call`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case action
        case callID = "call_id"
        case id
        case pendingSafetyChecks = "pending_safety_checks"
        case status
        case type
    }
}

/// The status of a computer tool call.
nonisolated public enum OpenAIComputerToolCallStatus: String, Decodable, Sendable {
    case completed
    case inProgress = "in_progress"
    case incomplete
}

/// A pending safety check for the computer call.
nonisolated public struct OpenAIComputerSafetyCheckResource: Decodable, Sendable {
    /// The ID of the pending safety check.
    public let id: String

    /// The type of the pending safety check.
    public let code: String?

    /// Details about the pending safety check.
    public let message: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case code
        case message
    }
}

/// A computer action.
nonisolated public enum OpenAIComputerActionResource: Decodable, Sendable {
    case click(OpenAIClickActionResource)
    case doubleClick(OpenAIDoubleClickActionResource)
    case drag(OpenAIDragActionResource)
    case keypress(OpenAIKeypressActionResource)
    case move(OpenAIMoveActionResource)
    case screenshot(OpenAIScreenshotActionResource)
    case scroll(OpenAIScrollActionResource)
    case type(OpenAITypeActionResource)
    case wait(OpenAIWaitActionResource)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "click":
            self = .click(try OpenAIClickActionResource(from: decoder))
        case "double_click":
            self = .doubleClick(try OpenAIDoubleClickActionResource(from: decoder))
        case "drag":
            self = .drag(try OpenAIDragActionResource(from: decoder))
        case "keypress":
            self = .keypress(try OpenAIKeypressActionResource(from: decoder))
        case "move":
            self = .move(try OpenAIMoveActionResource(from: decoder))
        case "screenshot":
            self = .screenshot(try OpenAIScreenshotActionResource(from: decoder))
        case "scroll":
            self = .scroll(try OpenAIScrollActionResource(from: decoder))
        case "type":
            self = .type(try OpenAITypeActionResource(from: decoder))
        case "wait":
            self = .wait(try OpenAIWaitActionResource(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown computer action type: \(type)"
            )
        }
    }
}

/// A click action.
nonisolated public struct OpenAIClickActionResource: Decodable, Sendable {
    /// Indicates which mouse button was pressed during the click.
    ///
    /// One of `left`, `right`, `wheel`, `back`, or `forward`.
    public let button: OpenAIClickButtonType

    /// Specifies the event type. For a click action, this property is always `click`.
    public let type: String

    /// The x-coordinate where the click occurred.
    public let x: Int

    /// The y-coordinate where the click occurred.
    public let y: Int

    private enum CodingKeys: String, CodingKey {
        case button
        case type
        case x
        case y
    }
}

/// The mouse button type for a click action.
nonisolated public enum OpenAIClickButtonType: String, Decodable, Sendable {
    case back
    case forward
    case left
    case right
    case wheel
}

/// A double click action.
nonisolated public struct OpenAIDoubleClickActionResource: Decodable, Sendable {
    /// Specifies the event type. For a double click action, this property is always set to `double_click`.
    public let type: String

    /// The x-coordinate where the double click occurred.
    public let x: Int

    /// The y-coordinate where the double click occurred.
    public let y: Int

    private enum CodingKeys: String, CodingKey {
        case type
        case x
        case y
    }
}

/// A drag action.
nonisolated public struct OpenAIDragActionResource: Decodable, Sendable {
    /// An array of coordinates representing the path of the drag action.
    public let path: [OpenAIDragPoint]

    /// Specifies the event type. For a drag action, this property is always set to `drag`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case path
        case type
    }
}

/// An x/y coordinate pair.
nonisolated public struct OpenAIDragPoint: Decodable, Sendable {
    /// The x-coordinate.
    public let x: Int

    /// The y-coordinate.
    public let y: Int

    private enum CodingKeys: String, CodingKey {
        case x
        case y
    }
}

/// A collection of keypresses the model would like to perform.
nonisolated public struct OpenAIKeypressActionResource: Decodable, Sendable {
    /// The combination of keys the model is requesting to be pressed.
    ///
    /// This is an array of strings, each representing a key.
    public let keys: [String]

    /// Specifies the event type. For a keypress action, this property is always set to `keypress`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case keys
        case type
    }
}

/// A mouse move action.
nonisolated public struct OpenAIMoveActionResource: Decodable, Sendable {
    /// Specifies the event type. For a move action, this property is always set to `move`.
    public let type: String

    /// The x-coordinate to move to.
    public let x: Int

    /// The y-coordinate to move to.
    public let y: Int

    private enum CodingKeys: String, CodingKey {
        case type
        case x
        case y
    }
}

/// A screenshot action.
nonisolated public struct OpenAIScreenshotActionResource: Decodable, Sendable {
    /// Specifies the event type. For a screenshot action, this property is always set to `screenshot`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case type
    }
}

/// A scroll action.
nonisolated public struct OpenAIScrollActionResource: Decodable, Sendable {
    /// Specifies the event type. For a scroll action, this property is always set to `scroll`.
    public let type: String

    /// The horizontal scroll distance.
    public let scrollX: Int?

    /// The vertical scroll distance.
    public let scrollY: Int?

    /// The x-coordinate where the scroll occurred.
    public let x: Int?

    /// The y-coordinate where the scroll occurred.
    public let y: Int?

    private enum CodingKeys: String, CodingKey {
        case type
        case scrollX = "scroll_x"
        case scrollY = "scroll_y"
        case x
        case y
    }
}

/// An action to type in text.
nonisolated public struct OpenAITypeActionResource: Decodable, Sendable {
    /// The text to type.
    public let text: String

    /// Specifies the event type. For a type action, this property is always set to `type`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}

/// A wait action.
nonisolated public struct OpenAIWaitActionResource: Decodable, Sendable {
    /// Specifies the event type. For a wait action, this property is always set to `wait`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case type
    }
}
