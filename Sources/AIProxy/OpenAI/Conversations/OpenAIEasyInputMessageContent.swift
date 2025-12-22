//
//  OpenAIInputMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: EasyInputMessage#content union, version 2.3.0, line 40790
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-input_message-content-input_item_content_list

public enum OpenAIEasyInputMessageContent {
    case text(String)

    /// A list of one or many input items to the model, containing different content types.
    case items([OpenAIInputContent])
}
