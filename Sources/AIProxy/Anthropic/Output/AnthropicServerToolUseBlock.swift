//
//  AnthropicServerToolUseBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `ServerToolUseBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#server_tool_use_block
nonisolated public struct AnthropicServerToolUseBlock: Decodable, Sendable {
    public let id: String
    public let input: [String: AIProxyJSONValue]
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case input
        case name
    }
}
