//
//  AnthropicCitationContentBlockLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `CitationContentBlockLocation` object:
/// https://console.anthropic.com/docs/en/api/messages#citation_content_block_location
nonisolated public struct AnthropicCitationContentBlockLocation: Decodable, Sendable {
    public let citedText: String
    public let documentIndex: Int
    public let documentTitle: String
    public let fileId: String
    public let startBlockIndex: Int
    public let endBlockIndex: Int

    private enum CodingKeys: String, CodingKey {
        case citedText = "cited_text"
        case documentIndex = "document_index"
        case documentTitle = "document_title"
        case fileId = "file_id"
        case startBlockIndex = "start_block_index"
        case endBlockIndex = "end_block_index"
    }
}
