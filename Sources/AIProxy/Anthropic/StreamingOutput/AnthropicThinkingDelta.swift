//
//  AnthropicThinkingDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents Anthropic's `thinking_delta` object:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicThinkingDelta: Decodable, Sendable {
    public let type = "thinking_delta"
    public let thinking: String

    private enum CodingKeys: String, CodingKey {
        case thinking
    }
}
