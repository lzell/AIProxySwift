//
//  AnthropicRedactedThinkingBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// Used when thinking content has been redacted for policy reasons.
///
/// Represents Anthropic's `RedactedThinkingBlockParam` object:
/// https://console.anthropic.com/docs/en/api/messages#redacted_thinking_block_param
nonisolated public struct AnthropicRedactedThinkingBlockParam: Encodable, Sendable {
    /// The redacted data.
    public let data: String

    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    public init(data: String) {
        self.data = data
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("redacted_thinking", forKey: .type)
        try container.encode(data, forKey: .data)
    }
}
