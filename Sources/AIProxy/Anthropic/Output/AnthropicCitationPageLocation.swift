//
//  AnthropicCitationPageLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CitationPageLocation` object:
/// https://console.anthropic.com/docs/en/api/messages#citation_page_location
nonisolated public struct AnthropicCitationPageLocation: Decodable, Sendable {
    public let citedText: String
    public let documentIndex: Int
    public let documentTitle: String
    public let fileId: String
    public let startPageNumber: Int
    public let endPageNumber: Int

    private enum CodingKeys: String, CodingKey {
        case citedText = "cited_text"
        case documentIndex = "document_index"
        case documentTitle = "document_title"
        case fileId = "file_id"
        case startPageNumber = "start_page_number"
        case endPageNumber = "end_page_number"
    }
}
