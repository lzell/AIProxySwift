//
//  OpenAIComputerAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

nonisolated public enum OpenAIComputerAction: Codable, Sendable {
    case click(OpenAIClickAction)
    case doubleClick(OpenAIDoubleClickAction)
    case drag(OpenAIDragAction)
    case keyPress(OpenAIKeyPressAction)
    case move(OpenAIMoveAction)
    case screenshot(OpenAIScreenshotAction)
    case scroll(OpenAIScrollAction)
    case type(OpenAITypeAction)
    case wait(OpenAIWaitAction)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "click":
            self = .click(try OpenAIClickAction(from: decoder))
        case "double_click":
            self = .doubleClick(try OpenAIDoubleClickAction(from: decoder))
        case "drag":
            self = .drag(try OpenAIDragAction(from: decoder))
        case "keypress":
            self = .keyPress(try OpenAIKeyPressAction(from: decoder))
        case "move":
            self = .move(try OpenAIMoveAction(from: decoder))
        case "screenshot":
            self = .screenshot(try OpenAIScreenshotAction(from: decoder))
        case "scroll":
            self = .scroll(try OpenAIScrollAction(from: decoder))
        case "type":
            self = .type(try OpenAITypeAction(from: decoder))
        case "wait":
            self = .wait(try OpenAIWaitAction(from: decoder))
        default:
            self = .futureProof
            logIf(.error)?.error("Unknown computer action type: \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .click(let action):
            try action.encode(to: encoder)
        case .doubleClick(let action):
            try action.encode(to: encoder)
        case .drag(let action):
            try action.encode(to: encoder)
        case .keyPress(let action):
            try action.encode(to: encoder)
        case .move(let action):
            try action.encode(to: encoder)
        case .screenshot(let action):
            try action.encode(to: encoder)
        case .scroll(let action):
            try action.encode(to: encoder)
        case .type(let action):
            try action.encode(to: encoder)
        case .wait(let action):
            try action.encode(to: encoder)
        case .futureProof:
            break
        }
    }
}
