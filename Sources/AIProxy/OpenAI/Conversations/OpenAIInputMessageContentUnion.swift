//
//  OpenAIInputMessageContentUnion.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

public enum OpenAIInputMessageContentUnion {
    case text(String)

    // typelias of InputMessageContentList
    case inputContentList([OpenAIInputContent])
}
