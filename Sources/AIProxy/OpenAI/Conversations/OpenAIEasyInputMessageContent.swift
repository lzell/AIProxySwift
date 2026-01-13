//
//  OpenAIInputMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: EasyInputMessage#content union, version 2.3.0, line 40790
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-input_message-content-input_item_content_list

nonisolated public enum OpenAIEasyInputMessageContent: Encodable, Sendable {
    /// A text input to the model.
    case text(String)

    /// A list of one or many input items to the model, containing different content types.
    case items([OpenAIInputContent])

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text):
            try container.encode(text)
        case .items(let items):
            try container.encode(items)
        }
    }
}
