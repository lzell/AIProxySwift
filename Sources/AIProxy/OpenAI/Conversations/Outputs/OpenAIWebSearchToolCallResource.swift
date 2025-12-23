//
//  OpenAIWebSearchToolCallResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: WebSearchToolCall, version 2.3.0, line 21767

/// The results of a web search tool call.
///
/// See the [web search guide](https://platform.openai.com/docs/guides/tools-web-search) for more information.
nonisolated public struct OpenAIWebSearchToolCallResource: Decodable, Sendable {
    /// An object describing the specific action taken in this web search call.
    ///
    /// Includes details on how the model used the web (search, open_page, find).
    public let action: OpenAIWebSearchActionResource

    /// The unique ID of the web search tool call.
    public let id: String

    /// The status of the web search tool call.
    public let status: OpenAIWebSearchToolCallStatus

    /// The type of the web search tool call. Always `web_search_call`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case action
        case id
        case status
        case type
    }
}

/// The status of a web search tool call.
nonisolated public enum OpenAIWebSearchToolCallStatus: String, Decodable, Sendable {
    case completed
    case failed
    case inProgress = "in_progress"
    case searching
}

/// An action taken in a web search call.
nonisolated public enum OpenAIWebSearchActionResource: Decodable, Sendable {
    case find(OpenAIWebSearchFindAction)
    case openPage(OpenAIWebSearchOpenPageAction)
    case search(OpenAIWebSearchSearchAction)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "find":
            self = .find(try OpenAIWebSearchFindAction(from: decoder))
        case "open_page":
            self = .openPage(try OpenAIWebSearchOpenPageAction(from: decoder))
        case "search":
            self = .search(try OpenAIWebSearchSearchAction(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown web search action type: \(type)"
            )
        }
    }
}

/// Action type "find": Searches for a pattern within a loaded page.
nonisolated public struct OpenAIWebSearchFindAction: Decodable, Sendable {
    /// The pattern or text to search for within the page.
    public let pattern: String

    /// The action type. Always `find`.
    public let type: String

    /// The URL of the page searched for the pattern.
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case pattern
        case type
        case url
    }
}

/// Action type "open_page" - Opens a specific URL from search results.
nonisolated public struct OpenAIWebSearchOpenPageAction: Decodable, Sendable {
    /// The action type. Always `open_page`.
    public let type: String

    /// The URL opened by the model.
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case type
        case url
    }
}

/// Action type "search" - Performs a web search query.
nonisolated public struct OpenAIWebSearchSearchAction: Decodable, Sendable {
    /// The search query.
    public let query: String

    /// The action type. Always `search`.
    public let type: String

    /// The sources used in the search.
    public let sources: [OpenAIWebSearchSource]?

    private enum CodingKeys: String, CodingKey {
        case query
        case type
        case sources
    }
}

/// A source used in the search.
nonisolated public struct OpenAIWebSearchSource: Decodable, Sendable {
    /// The type of source. Always `url`.
    public let type: String

    /// The URL of the source.
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case type
        case url
    }
}
