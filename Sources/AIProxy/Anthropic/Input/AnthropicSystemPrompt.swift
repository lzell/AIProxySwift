//
//  AnthropicSystemPrompt.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//


/// A system prompt is a way of providing context and instructions to Claude, such as specifying
/// a particular goal or role. See our guide to system prompts: https://docs.claude.com/en/docs/system-prompts
///
/// This type represents the `system` union of an Anthropic message:
/// https://console.anthropic.com/docs/en/api/messages/create
nonisolated public enum AnthropicSystemPrompt: Encodable, Sendable {
    /// A simple text string for the system prompt.
    case text(String)

    /// An array of text blocks for the system prompt.
    case blocks([AnthropicSystemTextBlockParam])

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let string):
            try container.encode(string)
        case .blocks(let blocks):
            try container.encode(blocks)
        }
    }
}

/// Added sugar to support `system: "hello world"`
extension AnthropicSystemPrompt: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .text(value)
    }
}
