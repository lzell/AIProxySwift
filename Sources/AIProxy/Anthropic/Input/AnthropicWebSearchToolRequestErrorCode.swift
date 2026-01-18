//
//  AnthropicWebSearchToolRequestErrorCode.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents the `error_code` field of Anthropic's `WebSearchToolRequestError` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_request_error
nonisolated public enum AnthropicWebSearchToolRequestErrorCode: String, Encodable, Sendable {
    case invalidToolInput = "invalid_tool_input"
    case unavailable = "unavailable"
    case maxUsesExceeded = "max_uses_exceeded"
    case tooManyRequests = "too_many_requests"
    case queryTooLong = "query_too_long"
}
