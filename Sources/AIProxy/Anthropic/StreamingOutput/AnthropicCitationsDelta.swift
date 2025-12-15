//
//  AnthropicCitationsDelta.swift
//  AIProxy
//
//  Created by Lou Zell on 12/12/25.
//

/// Represents Anthropic's `citations_delta` object:
/// https://platform.claude.com/docs/en/build-with-claude/citations#streaming-support
nonisolated public struct AnthropicCitationsDelta: Decodable, Sendable {
    public let type = "citations_delta"
    public let citation: AnthropicTextCitation

    private enum CodingKeys: String, CodingKey {
        case citation
    }
}
