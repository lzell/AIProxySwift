//
//  OpenAIConversationsWebSearchToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A web search tool call item in a conversation.
nonisolated public struct OpenAIConversationsWebSearchToolCall: Decodable, Sendable {
    /// The type of the item, always "web_search_call".
    public let type: String

    /// The unique ID of the web search call.
    public let id: String

    /// The status of the web search call.
    public let status: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
    }
}
