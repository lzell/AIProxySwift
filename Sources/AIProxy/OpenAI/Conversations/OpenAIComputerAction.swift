//
//  OpenAIComputerAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

nonisolated public enum OpenAIComputerAction: Encodable, Sendable {
    case click(OpenAIClickAction)
    case doubleClick(OpenAIDoubleClickAction)
    case drag(OpenAIDragAction)
    case keyPress(OpenAIKeyPressAction)
    case move(OpenAIMoveAction)
    case screenshot(OpenAIScreenshotAction)
    case scroll(OpenAIScrollAction)
    case type(OpenAITypeAction)
    case wait(OpenAIWaitAction)
}
