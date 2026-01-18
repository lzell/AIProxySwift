//
//  AnthropicThinkingBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `ThinkingBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#thinking_block
nonisolated public struct AnthropicThinkingBlock: Decodable, Sendable {
    public let signature: String
    public let thinking: String
}
