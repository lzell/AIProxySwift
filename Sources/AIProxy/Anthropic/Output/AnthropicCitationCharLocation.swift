//
//  AnthropicCitationCharLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CitationCharLocation` object:
/// https://console.anthropic.com/docs/en/api/messages#citation_char_location
nonisolated public struct AnthropicCitationCharLocation: Decodable, Sendable {
    public let citedText: String
    public let documentIndex: Int
    public let documentTitle: String
    public let fileId: String
    public let startCharIndex: Int
    public let endCharIndex: Int

    private enum CodingKeys: String, CodingKey {
        case citedText = "cited_text"
        case documentIndex = "document_index"
        case documentTitle = "document_title"
        case fileId = "file_id"
        case startCharIndex = "start_char_index"
        case endCharIndex = "end_char_index"
    }
}
