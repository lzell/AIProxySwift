//
//  OpenAIComputerAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

nonisolated public enum OpenAIComputerAction: Encodable, Decodable, Sendable {
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
            self = .futureProof
            logIf(.error)?.error("Unknown computer action type: \(type)")
        }
    }

}
