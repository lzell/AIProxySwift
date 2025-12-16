//
//  AnthropicContentBlockStop.swift
//  AIProxy
//
//  Created by Lou Zell on 12/12/25.
//

/// Represents Anthropic's `content_block_stop` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicContentBlockStop: Decodable, Sendable {
    public let type = "content_block_stop"
    public let index: Int

    private enum CodingKeys: String, CodingKey {
        case index
    }
}
