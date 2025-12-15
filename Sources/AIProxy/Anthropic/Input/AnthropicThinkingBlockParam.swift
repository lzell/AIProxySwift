//
//  AnthropicThinkingBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// A thinking content block, representing Claude's internal reasoning.
///
/// Used when extended thinking is enabled to pass thinking blocks back to the model
/// in multi-turn conversations.
nonisolated public struct AnthropicThinkingBlockParam: Encodable, Sendable {
    /// The cryptographic signature of the thinking content.
    public let signature: String

    /// The thinking content.
    public let thinking: String

    private enum CodingKeys: String, CodingKey {
        case type
        case signature
        case thinking
    }

    public init(
        signature: String,
        thinking: String
    ) {
        self.signature = signature
        self.thinking = thinking
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("thinking", forKey: .type)
        try container.encode(signature, forKey: .signature)
        try container.encode(thinking, forKey: .thinking)
    }
}
