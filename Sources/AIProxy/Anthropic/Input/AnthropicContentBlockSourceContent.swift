//
//  AnthropicContentBlockSourceContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents Anthropic's `ContentBlockSourceContent` type:
/// https://console.anthropic.com/docs/en/api/messages#content_block_source_content
nonisolated public enum AnthropicContentBlockSourceContent: Encodable, Sendable {
    case text(AnthropicTextBlockParam)
    case image(AnthropicImageBlockParam)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let block):
            try block.encode(to: encoder)
        case .image(let block):
            try block.encode(to: encoder)
        }
    }
}
