//
//  AnthropicSignatureDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents Anthropic's `signature_delta` object:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicSignatureDelta: Decodable, Sendable {
    public let type = "signature_delta"
    public let signature: String

    private enum CodingKeys: String, CodingKey {
        case signature
    }
}
