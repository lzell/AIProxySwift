//
//  OpenAIOutputMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 1/21/26.
//
// OpenAPI spec: OutputMessageContent, version 2.3.0, line 47246
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-output_message-content

/// Content of an output message.
nonisolated public enum OpenAIOutputMessageContent: Encodable, Sendable {
    /// A text output from the model.
    case outputText(OpenAIOutputText)

    /// A refusal from the model.
    case refusal(OpenAIRefusal)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .outputText(let content):
            try content.encode(to: encoder)
        case .refusal(let content):
            try content.encode(to: encoder)
        }
    }
}
