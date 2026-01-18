//
//  AnthropicMessageParamContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/11/25.
//

/// Represents the `content` union of Anthropic's `MessageParam` object:
/// https://console.anthropic.com/docs/en/api/messages#message_param
nonisolated public enum AnthropicMessageParamContent: Encodable, Sendable {
    case text(String)
    case blocks([AnthropicContentBlockParam])

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let string):
            try container.encode(string)
        case .blocks(let blocks):
            try container.encode(blocks)
        }
    }
}

extension AnthropicMessageParamContent: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = AnthropicContentBlockParam

    public init(arrayLiteral elements: AnthropicContentBlockParam...) {
        self = .blocks(elements)
    }
}

extension AnthropicMessageParamContent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .text(value)
    }
}
