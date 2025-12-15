//
//  AnthropicURLImageSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents Anthropic's `URLImageSource` object:
/// https://console.anthropic.com/docs/en/api/messages#url_image_source
public struct AnthropicURLImageSource: Codable, Sendable {
    public let type: String
    public let url: String
    
    public init(url: String) {
        self.type = "url"
        self.url = url
    }
}
