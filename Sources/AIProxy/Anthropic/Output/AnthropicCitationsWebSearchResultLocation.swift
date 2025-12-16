//
//  AnthropicCitationsWebSearchResultLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CitationsWebSearchResultLocation` object:
/// https://console.anthropic.com/docs/en/api/messages#citations_web_search_result_location
nonisolated public struct AnthropicCitationsWebSearchResultLocation: Decodable, Sendable {
    public let citedText: String
    public let encryptedIndex: String
    public let title: String
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case citedText = "cited_text"
        case encryptedIndex = "encrypted_index"
        case title
        case url
    }
}
