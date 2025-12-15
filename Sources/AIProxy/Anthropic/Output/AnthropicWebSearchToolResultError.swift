//
//  AnthropicWebSearchToolResultError.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `WebSearchToolResultError` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_result_error
nonisolated public struct AnthropicWebSearchToolResultError: Decodable, Sendable {
    public let errorCode: AnthropicWebSearchToolResultErrorCode

    private enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
    }
}
