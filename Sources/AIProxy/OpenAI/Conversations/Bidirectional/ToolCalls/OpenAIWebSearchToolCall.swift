//
//  OpenAIWebSearchToolCall.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: WebSearchToolCall, version 2.3.0, line 63846
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-web_search_tool_call

/// The results of a web search tool call.
///
/// See the [web search guide](https://platform.openai.com/docs/guides/tools-web-search) for more information.
nonisolated public struct OpenAIWebSearchToolCall: Codable, Sendable {
    /// An object describing the specific action taken in this web search call.
    ///
    /// Includes details on how the model used the web (`search`, `open_page`, `find`).
    public let action: OpenAIWebSearchAction

    /// The unique ID of the web search tool call.
    public let id: String

    /// The status of the web search tool call.
    public let status: Status

    /// The type of the web search tool call. Always `web_search_call`.
    public let type = "web_search_call"

    /// Creates a new web search tool call.
    /// - Parameters:
    ///   - action: An object describing the specific action taken in this web search call.
    ///   - id: The unique ID of the web search tool call.
    ///   - status: The status of the web search tool call.
    public init(
        action: OpenAIWebSearchAction,
        id: String,
        status: Status
    ) {
        self.action = action
        self.id = id
        self.status = status
    }

    private enum CodingKeys: String, CodingKey {
        case action
        case id
        case status
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIWebSearchToolCall {
    /// The status of the web search tool call.
    public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case searching
        case completed
        case failed
    }
}
