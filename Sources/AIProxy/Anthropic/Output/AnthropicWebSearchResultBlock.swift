//
//  AnthropicWebSearchResultBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `WebSearchResultBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_result_block
nonisolated public struct AnthropicWebSearchResultBlock: Decodable, Sendable {
    public let encryptedContent: String
    public let pageAge: String
    public let title: String
    public let url: String

    private enum CodingKeys: String, CodingKey {
        case encryptedContent = "encrypted_content"
        case pageAge = "page_age"
        case title
        case url
    }
}
