//
//  AnthropicMessageResponseBody.swift
//
//
//  Created by Lou Zell on 7/28/24.
//

import Foundation

/// All docstrings in this file are from: https://docs.anthropic.com/en/api/messages
public struct AnthropicMessageResponseBody: Decodable {
    public var content: [AnthropicMessageResponseContent]
    public let id: String
    public let model: String
    public let role: String
    public let stopReason: String?
    public let stopSequence: String?
    public let type: String
    public let usage: AnthropicMessageUsage

    private enum CodingKeys: String, CodingKey {
        case content
        case id
        case model
        case role
        case stopReason = "stop_reason"
        case stopSequence = "stop_sequence"
        case type
        case usage
    }
}


public enum AnthropicMessageResponseContent: Decodable {
    case text(String)
    case toolUse(id: String, name: String, input: [String: AIProxyJSONValue])

    private enum CodingKeys: String, CodingKey {
        case type
        case text
        case id
        case name
        case input
    }

    private enum ContentType: String, Decodable {
        case text
        case toolUse = "tool_use"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ContentType.self, forKey: .type)
        switch type {
        case .text:
            let value = try container.decode(String.self, forKey: .text)
            self = .text(value)
        case .toolUse:
            let id = try container.decode(String.self, forKey: .id)
            let name = try container.decode(String.self, forKey: .name)
            let input = try container.decode([String: AIProxyJSONValue].self, forKey: .input)
            self = .toolUse(id: id, name: name, input: input)
        }
    }
}


public struct AnthropicMessageUsage: Decodable {
    public let inputTokens: Int
    public let outputTokens: Int

    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
    }
}
