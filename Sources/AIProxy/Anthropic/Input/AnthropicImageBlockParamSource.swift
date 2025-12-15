//
//  AnthropicImageBlockParamSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Source for an image, either base64-encoded or from a URL.
/// Represents the union type for the `source` field of Anthropic's `ImageBlockParam` object.
/// https://console.anthropic.com/docs/en/api/messages#image_block_param
nonisolated public enum AnthropicImageBlockParamSource: Encodable, Sendable {
    case base64(data: String, mediaType: AnthropicImageMediaType)
    case url(String)

    private enum CodingKeys: String, CodingKey {
        case type
        case data
        case mediaType = "media_type"
        case url
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .base64(let data, let mediaType):
            try container.encode("base64", forKey: .type)
            try container.encode(data, forKey: .data)
            try container.encode(mediaType, forKey: .mediaType)
        case .url(let url):
            try container.encode("url", forKey: .type)
            try container.encode(url, forKey: .url)
        }
    }
}
