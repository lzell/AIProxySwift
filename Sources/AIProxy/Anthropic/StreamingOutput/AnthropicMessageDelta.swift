//
//  AnthropicMessageDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/12/25.
//

/// Represents Anthropic's `message_delta` streaming event::
/// https://platform.claude.com/docs/en/build-with-claude/streaming
public struct AnthropicMessageDelta: Decodable, Sendable {
    public let type = "message_delta"
    public let delta: Delta
    public let usage: AnthropicUsage?

    private enum CodingKeys: String, CodingKey {
        case delta
        case usage
    }
}

extension AnthropicMessageDelta {
    public struct Delta: Decodable, Sendable {
        public let stopReason: AnthropicStopReason?
        public let stopSequence: String?

        private enum CodingKeys: String, CodingKey {
            case stopReason = "stop_reason"
            case stopSequence = "stop_sequence"
        }
    }
}
