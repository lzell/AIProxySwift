//
//  AnthropicStreamingEvent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/8/25.
//

/// Union type of all possible events streamed back during Anthropic's streaming message response.
nonisolated public enum AnthropicStreamingEvent: Decodable, Sendable {
    case messageStart(AnthropicMessageStart)
    case contentBlockStart(AnthropicContentBlockStart)
    case contentBlockDelta(AnthropicContentBlockDelta)
    case contentBlockStop(AnthropicContentBlockStop)
    case messageDelta(AnthropicMessageDelta)
    case messageStop(AnthropicMessageStop)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "message_start":
            self = .messageStart(try AnthropicMessageStart(from: decoder))
        case "content_block_start":
            self = .contentBlockStart(try AnthropicContentBlockStart(from: decoder))
        case "content_block_delta":
            self = .contentBlockDelta(try AnthropicContentBlockDelta(from: decoder))
        case "content_block_stop":
            self = .contentBlockStop(try AnthropicContentBlockStop(from: decoder))
        case "message_delta":
            self = .messageDelta(try AnthropicMessageDelta(from: decoder))
        case "message_stop":
            self = .messageStop(try AnthropicMessageStop(from: decoder))
        default:
            logIf(.info)?.info("Received unknown Anthropic streaming event of type \(type).")
            self = .futureProof
        }
    }
}
