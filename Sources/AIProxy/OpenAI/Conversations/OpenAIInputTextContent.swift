//
//  OpenAIInputTextContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

nonisolated public struct OpenAIInputTextContent: Encodable, Sendable {
    /// The type of the input item. Always `input_text`.
    public let type = "input_text"

    /// The text input to the model.
    public let text: String

    public init(text: String) {
        self.text = text
    }
}
