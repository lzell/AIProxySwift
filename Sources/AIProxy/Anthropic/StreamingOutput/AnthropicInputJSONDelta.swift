//
//  AnthropicInputJSONDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents Anthropic's `input_json_delta` object:
/// https://platform.claude.com/docs/en/build-with-claude/streaming
nonisolated public struct AnthropicInputJSONDelta: Decodable, Sendable {
    public let type = "input_json_delta"
    public let partialJSON: String

    enum CodingKeys: String, CodingKey {
        case partialJSON = "partial_json"
    }
}
