//
//  AnthropicContentBlockStart.swift
//  AIProxy
//
//  Created by Lou Zell on 12/8/25.
//

/// Represents Anthropic's `content_block_start` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicContentBlockStart: Decodable, Sendable {
    public let type = "content_block_start"
    public let index: Int
    public let contentBlock: AnthropicContentBlock

    private enum CodingKeys: String, CodingKey {
        case index
        case contentBlock = "content_block"
    }
}
