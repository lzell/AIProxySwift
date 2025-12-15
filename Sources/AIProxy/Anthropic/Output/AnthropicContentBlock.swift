//
//  AnthropicContentBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Typealias for backwards-compatibility with sdkVersion <= 0.134.0
public typealias AnthropicMessageResponseContent = AnthropicContentBlock

/// Represents Anthropic's `ContentBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#content_block
nonisolated public enum AnthropicContentBlock: Decodable, Sendable {
    case textBlock(AnthropicTextBlock)
    case thinkingBlock(AnthropicThinkingBlock)
    case redactedThinkingBlock(AnthropicRedactedThinkingBlock)
    case toolUseBlock(AnthropicToolUseBlock)
    case serverToolUseBlock(AnthropicServerToolUseBlock)
    case webSearchToolResultBlock(AnthropicWebSearchToolResultBlock)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "text":
            self = .textBlock(try AnthropicTextBlock(from: decoder))
        case "thinking":
            self = .thinkingBlock(try AnthropicThinkingBlock(from: decoder))
        case "redacted_thinking":
            self = .redactedThinkingBlock(try AnthropicRedactedThinkingBlock(from: decoder))
        case "tool_use":
            self = .toolUseBlock(try AnthropicToolUseBlock(from: decoder))
        case "server_tool_use":
            self = .serverToolUseBlock(try AnthropicServerToolUseBlock(from: decoder))
        case "web_search_tool_result":
            self = .webSearchToolResultBlock(try AnthropicWebSearchToolResultBlock(from: decoder))
        default:
            self = .futureProof
        }
    }
}
