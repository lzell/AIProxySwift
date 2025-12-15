//
//  AnthropicContentBlockDeltaUnion.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents the `delta` field of the `content_block_delta` streaming event:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public enum AnthropicContentBlockDeltaUnion: Decodable, Sendable {
    case textDelta(AnthropicTextDelta)
    case inputJSONDelta(AnthropicInputJSONDelta)
    case thinkingDelta(AnthropicThinkingDelta)
    case signatureDelta(AnthropicSignatureDelta)

    /// https://platform.claude.com/docs/en/build-with-claude/citations#streaming-support
    case citationsDelta(AnthropicCitationsDelta)

    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "text_delta":
            self = .textDelta(try AnthropicTextDelta(from: decoder))
        case "input_json_delta":
            self = .inputJSONDelta(try AnthropicInputJSONDelta(from: decoder))
        case "thinking_delta":
            self = .thinkingDelta(try AnthropicThinkingDelta(from: decoder))
        case "signature_delta":
            self = .signatureDelta(try AnthropicSignatureDelta(from: decoder))
        case "citations_delta":
            self = .citationsDelta(try AnthropicCitationsDelta(from: decoder))
        default:
            self = .futureProof
            logIf(.info)?.info("AIProxy: received a streaming content_block_delta with type we don't understand: \(type)")
        }
    }
}

