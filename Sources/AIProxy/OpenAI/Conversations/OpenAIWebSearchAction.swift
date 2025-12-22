//
//  OpenAIWebSearchAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public enum OpenAIWebSearchAction: Encodable, Sendable {
    case search(OpenAISearchAction)
    case openPage(OpenAIOpenPageAction)
    case find(OpenAIFindAction)
}
