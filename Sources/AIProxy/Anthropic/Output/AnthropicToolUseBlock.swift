//
//  AnthropicToolUseBlock.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `ToolUseBlock` object:
/// https://console.anthropic.com/docs/en/api/messages#tool_use_block
nonisolated public struct AnthropicToolUseBlock: Decodable, Sendable {
    public let id: String
    public let input: [String: any Sendable]
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case input
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.input = (try container.decode([String: AIProxyJSONValue].self, forKey: .input)).untypedDictionary
        self.name = try container.decode(String.self, forKey: .name)
    }

}
