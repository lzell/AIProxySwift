//
//  AnthropicMessageStart.swift
//  AIProxy
//
//  Created by Lou Zell on 12/12/25.
//

/// Represents Anthropic's `message_start` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicMessageStart: Decodable, Sendable {
    public let type = "message_start"
    public let message: AnthropicMessage

    private enum CodingKeys: String, CodingKey {
        case message
    }
}
