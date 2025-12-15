//
//  AnthropicWebSearchToolRequestError.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents Anthropic's `WebSearchToolRequestError` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_request_error
nonisolated public struct AnthropicWebSearchToolRequestError: Encodable, Sendable {
    /// The error code.
    public let errorCode: AnthropicWebSearchToolRequestErrorCode

    private enum CodingKeys: String, CodingKey {
        case type
        case errorCode = "error_code"
    }

    public init(errorCode: AnthropicWebSearchToolRequestErrorCode) {
        self.errorCode = errorCode
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("web_search_tool_result_error", forKey: .type)
        try container.encode(errorCode, forKey: .errorCode)
    }
}
