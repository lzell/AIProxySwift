//
//  AnthropicServerToolUsage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `ServerToolUsage` object:
/// https://console.anthropic.com/docs/en/api/messages#server_tool_usage
nonisolated public struct AnthropicServerToolUsage: Decodable, Sendable {
    /// The number of web search tool requests.
    public let webSearchRequests: Int

    private enum CodingKeys: String, CodingKey {
        case webSearchRequests = "web_search_requests"
    }
}
