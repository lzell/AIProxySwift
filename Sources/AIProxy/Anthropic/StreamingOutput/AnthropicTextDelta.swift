//
//  AnthropicTextDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents Anthropic's `text_delta` object:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicTextDelta: Decodable, Sendable {
    public let type = "text_delta"
    public let text: String

    private enum CodingKeys: String, CodingKey {
        case text
    }
}
