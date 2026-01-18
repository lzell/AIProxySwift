//
//  AnthropicWebSearchToolResultBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `WebSearchToolResultBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_result_block
nonisolated public struct AnthropicWebSearchToolResultBlock: Decodable, Sendable {
    public let content: AnthropicWebSearchToolResultBlockContent
    public let toolUseId: String

    private enum CodingKeys: String, CodingKey {
        case content
        case toolUseId = "tool_use_id"
    }
}
