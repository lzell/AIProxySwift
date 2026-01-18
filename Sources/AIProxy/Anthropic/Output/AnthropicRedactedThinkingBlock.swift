//
//  AnthropicRedactedThinkingBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `RedactedThinkingBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#redacted_thinking_block
nonisolated public struct AnthropicRedactedThinkingBlock: Decodable, Sendable {
    public let data: String

    private enum CodingKeys: String, CodingKey {
        case data
    }
}
