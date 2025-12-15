//
//  AnthropicCitationsSearchResultLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CitationsSearchResultLocation` object:
/// https://console.anthropic.com/docs/en/api/messages#citations_search_result_location
nonisolated public struct AnthropicCitationsSearchResultLocation: Decodable, Sendable {
    public let citedText: String
    public let searchResultIndex: Int
    public let source: String
    public let title: String
    public let startBlockIndex: Int
    public let endBlockIndex: Int

    private enum CodingKeys: String, CodingKey {
        case citedText = "cited_text"
        case searchResultIndex = "search_result_index"
        case source
        case title
        case startBlockIndex = "start_block_index"
        case endBlockIndex = "end_block_index"
    }
}
