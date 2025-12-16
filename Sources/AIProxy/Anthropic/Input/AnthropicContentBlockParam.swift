//
//  AnthropicContentBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

import Foundation

/// For backwards-compatibility with SDK versions <= "0.134.0"
public typealias AnthropicInputContent = AnthropicContentBlockParam

/// A content block that can be sent as input in a message.
///
/// Represents Anthropic's `ContentBlockParam` type:
/// https://console.anthropic.com/docs/en/api/messages#content_block_param
nonisolated public enum AnthropicContentBlockParam: Encodable, Sendable {
    case textBlock(AnthropicTextBlockParam)
    case imageBlock(AnthropicImageBlockParam)
    case documentBlock(AnthropicDocumentBlockParam)
    case searchResultBlock(AnthropicSearchResultBlockParam)
    case thinkingBlock(AnthropicThinkingBlockParam)
    case redactedThinkingBlock(AnthropicRedactedThinkingBlockParam)
    case toolUseBlock(AnthropicToolUseBlockParam)
    case toolResultBlock(AnthropicToolResultBlockParam)
    case serverToolUseBlock(AnthropicServerToolUseBlockParam)
    case webSearchToolResultBlock(AnthropicWebSearchToolResultBlockParam)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .textBlock(let block):
            try block.encode(to: encoder)
        case .imageBlock(let block):
            try block.encode(to: encoder)
        case .documentBlock(let block):
            try block.encode(to: encoder)
        case .searchResultBlock(let block):
            try block.encode(to: encoder)
        case .thinkingBlock(let block):
            try block.encode(to: encoder)
        case .redactedThinkingBlock(let block):
            try block.encode(to: encoder)
        case .toolUseBlock(let block):
            try block.encode(to: encoder)
        case .toolResultBlock(let block):
            try block.encode(to: encoder)
        case .serverToolUseBlock(let block):
            try block.encode(to: encoder)
        case .webSearchToolResultBlock(let block):
            try block.encode(to: encoder)
        }
    }
}
