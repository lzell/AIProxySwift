//
//  AnthropicBase64ImageSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents Anthropic's `Base64ImageSource` object:
/// https://console.anthropic.com/docs/en/api/messages#base64_image_source
nonisolated public struct AnthropicBase64ImageSource: Codable, Sendable {
    public let type: String
    public let data: String
    public let mediaType: MediaType

    private enum CodingKeys: String, CodingKey {
        case type
        case data
        case mediaType = "media_type"
    }

    public init(data: String, mediaType: MediaType) {
        self.type = "base64"
        self.data = data
        self.mediaType = mediaType
    }
}

extension AnthropicBase64ImageSource {
    nonisolated public enum MediaType: String, Codable, Sendable {
        case jpeg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case webp = "image/webp"
    }
}
