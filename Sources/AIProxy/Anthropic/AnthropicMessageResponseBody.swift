//
//  AnthropicMessageResponseBody.swift
//
//
//  Created by Lou Zell on 7/28/24.
//

import Foundation

/// All docstrings in this file are from: https://docs.anthropic.com/en/api/messages
/// Important: to decode this type, please use the `safeDecode` static method. Special handling is applied
/// to accommodate a flexible JSON schema for Anthropic tool use.
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
    case toolUse(id: String, name: String, input: [String: Any])

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
            throw AIProxyError.assertion("Inconsistency. Expected deserialization using escape hatch.")
        }
    }
}


public struct AnthropicMessageUsage: Decodable {
    let inputTokens: Int
    let outputTokens: Int

    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
    }
}


// Special handling of tool decoding
internal extension AnthropicMessageResponseBody {
    static func safeDecode(from data: Data) throws -> AnthropicMessageResponseBody {
        guard var jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else
        {
            throw AIProxyError.assertion("Could not convert response into a JSONObject")
        }

        // If there are any 'type': "tool_use", pluck them out
        var indicesToPluck = [Int]()
        let contents = (jsonObject["content"] as? [[String: Any]]) ?? []
        for (index, messageContent) in contents.enumerated() {
            if (messageContent["type"] as? String == "tool_use") {
                indicesToPluck.append(index)
            }
        }

        // Build up the replacement content
        var replacement = [[String: Any]]()
        let idxSet = Set(indicesToPluck)
        for (index, messageContent) in contents.enumerated() {
            if (!idxSet.contains(index)) {
                replacement.append(messageContent)
            }
        }
        jsonObject["content"] = replacement

        // Use decodable on the remainder
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        let decoder = JSONDecoder()
        var mappedResult = try decoder.decode(Self.self, from: data)

        // Reinsert the plucked out content
        for idx in indicesToPluck {
            // This algorithm assumes the indices are sorted in ascending order.
            // Insert them in their proper location.
            guard let toolId = contents[idx]["id"] as? String,
                  let toolName = contents[idx]["name"] as? String,
                  let toolInput = contents[idx]["input"] as? [String: Any] else {
                throw AIProxyError.assertion("Unexpected Anthropic tool fields in the response")
            }
            mappedResult.content.insert(.toolUse(id: toolId, name: toolName, input: toolInput), at: idx)
        }
        return mappedResult
    }
}
