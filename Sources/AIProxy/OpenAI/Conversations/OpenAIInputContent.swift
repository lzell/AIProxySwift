//
//  OpenAIInputContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

public enum OpenAIInputContent {
    case text(OpenAIInputTextContent)
    case image(OpenAIInputImageContent)
    case file(OpenAIInputFileContent)
}
