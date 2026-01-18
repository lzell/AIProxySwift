//
//  AnthropicWebSearchToolResultBlockContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `WebSearchToolResultBlockContent` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_result_block_content
nonisolated public enum AnthropicWebSearchToolResultBlockContent: Decodable, Sendable {
    case results([AnthropicWebSearchResultBlock])
    case error(AnthropicWebSearchToolResultError)
    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let type = try? container.decode(String.self, forKey: .type) else {
            self = .futureProof
            return
        }

        switch type {
        case "web_search_result":
            self = .results(try [AnthropicWebSearchResultBlock](from: decoder))
        case "web_search_tool_result_error":
            self = .error(try AnthropicWebSearchToolResultError(from: decoder))
        default:
            self = .futureProof
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }
}
