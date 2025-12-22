//
//  OpenAIInputContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: InputContent, version 2.3.0, line 44803
//

nonisolated public enum OpenAIInputContent: Encodable, Sendable {
    case text(OpenAIInputTextContent)
    case image(OpenAIInputImageContent)
    case file(OpenAIInputFileContent)
}

