//
//  AnthropicWebSearchToolResultContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// The content of a web search tool result, either search results or an error.
nonisolated public enum AnthropicWebSearchToolResultContent: Encodable, Sendable {
    case results([AnthropicWebSearchResultBlockParam])
    case error(AnthropicWebSearchToolRequestError)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .results(let results):
            var container = encoder.singleValueContainer()
            try container.encode(results)
        case .error(let error):
            try error.encode(to: encoder)
        }
    }
}
