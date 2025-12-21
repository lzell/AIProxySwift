//
//  OpenAIInputMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

// TODO: Remove this typealias and use the array type def instead
public typealias OpenAIInputMessageContentList = [OpenAIInputContent]

public enum OpenAIEasyInputMessageContent {
    case text(String)

    /// A list of one or many input items to the model, containing different content types.
    case inputContentList(OpenAIInputMessageContentList)
}
