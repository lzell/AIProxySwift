//
//  AnthropicWebSearchToolResultErrorCode.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents the `error_code` field for Anthropic's `WebSearchToolResultError` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_result_error
nonisolated public enum AnthropicWebSearchToolResultErrorCode: String, Decodable, Sendable {
    case invalidToolInput = "invalid_tool_input"
    case unavailable = "unavailable"
    case maxUsesExceeded = "max_uses_exceeded"
    case tooManyRequests = "too_many_requests"
    case queryTooLong = "query_too_long"
    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = Self(rawValue: value) ?? .futureProof
    }
}
