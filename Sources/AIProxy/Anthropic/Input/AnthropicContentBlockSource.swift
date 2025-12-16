//
//  AnthropicContentBlockSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Content block source containing structured content.
/// https://console.anthropic.com/docs/en/api/messages#content_block_source
nonisolated public struct AnthropicContentBlockSource: Encodable, Sendable {
    /// The content, either as a string or array of content blocks.
    public let content: [AnthropicContentBlockSourceContent]

    private enum CodingKeys: String, CodingKey {
        case type
        case content
    }

    public init(content: [AnthropicContentBlockSourceContent]) {
        self.content = content
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("content", forKey: .type)
        try container.encode(content, forKey: .content)
    }
}
