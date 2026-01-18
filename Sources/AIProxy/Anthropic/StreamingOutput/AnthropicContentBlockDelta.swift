//
//  AnthropicContentBlockDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents Anthropic's `content_block_delta` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicContentBlockDelta: Decodable, Sendable {
    public let type = "content_block_delta"
    public let index: Int
    public let delta: AnthropicContentBlockDeltaUnion

    private enum CodingKeys: String, CodingKey {
        case index
        case delta
    }
}
