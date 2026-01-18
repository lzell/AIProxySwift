//
//  AnthropicTextBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `TextBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#text_block
nonisolated public struct AnthropicTextBlock: Decodable, Sendable {
    /// The text content.
    public let text: String

    /// Citations supporting the text block.
    ///
    /// The type of citation returned will depend on the type of document being cited.
    /// Citing a PDF results in `pageLocation`, plain text results in `charLocation`,
    /// and content document results in `contentBlockLocation`.
    public let citations: [AnthropicTextCitation]?

    private enum CodingKeys: String, CodingKey {
        case text
        case citations
    }
}
