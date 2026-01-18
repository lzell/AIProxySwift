//
//  AnthropicMessageStop.swift
//  AIProxy
//
//  Created by Lou Zell on 12/12/25.
//

/// Represents Anthropic's `message_stop` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
public struct AnthropicMessageStop: Decodable, Sendable {
    public let type = "message_stop"

    private enum CodingKeys: CodingKey {}
}
