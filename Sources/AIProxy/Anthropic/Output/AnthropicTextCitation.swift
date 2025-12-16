//
//  AnthropicTextCitation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `TextCitation` object:
/// https://console.anthropic.com/docs/en/api/messages#text_citation
nonisolated public enum AnthropicTextCitation: Decodable, Sendable {
    case charLocation(AnthropicCitationCharLocation)
    case pageLocation(AnthropicCitationPageLocation)
    case contentBlockLocation(AnthropicCitationContentBlockLocation)
    case webSearchResultLocation(AnthropicCitationsWebSearchResultLocation)
    case searchResultLocation(AnthropicCitationsSearchResultLocation)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "char_location":
            self = .charLocation(try AnthropicCitationCharLocation(from: decoder))
        case "page_location":
            self = .pageLocation(try AnthropicCitationPageLocation(from: decoder))
        case "content_block_location":
            self = .contentBlockLocation(try AnthropicCitationContentBlockLocation(from: decoder))
        case "web_search_result_location":
            self = .webSearchResultLocation(try AnthropicCitationsWebSearchResultLocation(from: decoder))
        case "search_result_location":
            self = .searchResultLocation(try AnthropicCitationsSearchResultLocation(from: decoder))
        default:
            self = .futureProof
        }
    }
}
