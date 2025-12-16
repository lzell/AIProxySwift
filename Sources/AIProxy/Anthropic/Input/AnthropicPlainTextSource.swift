//
//  AnthropicPlainTextSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents Anthropic's `PlainTextSource` type.
/// https://console.anthropic.com/docs/en/api/messages#plain_text_source
nonisolated public struct AnthropicPlainTextSource: Codable, Sendable {
    public let type: String
    public let mediaType: String
    public let data: String
    
    private enum CodingKeys: String, CodingKey {
        case type
        case mediaType = "media_type"
        case data
    }
    
    public init(data: String) {
        self.type = "text"
        self.mediaType = "text/plain"
        self.data = data
    }
}
