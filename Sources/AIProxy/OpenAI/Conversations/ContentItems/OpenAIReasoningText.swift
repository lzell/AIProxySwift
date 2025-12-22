//
//  OpenAIReasoningText.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public struct OpenAIReasoningText: Encodable, Sendable {
    /// The reasoning text from the model.
    public let text: String

    /// The type of the reasoning text. Always `reasoning_text`.
    public let type = "reasoning_text"

    public init(text: String) {
        self.text = text
    }
}
