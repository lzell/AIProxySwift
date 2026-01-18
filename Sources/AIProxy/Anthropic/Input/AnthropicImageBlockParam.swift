//
//  AnthropicImageBlockParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// Represents Anthropic's `ImageBlockParam` type
/// https://console.anthropic.com/docs/en/api/messages#image_block_param
nonisolated public struct AnthropicImageBlockParam: Encodable, Sendable {
    /// The image source (base64 or URL).
    public let source: AnthropicImageBlockParamSource

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    private enum CodingKeys: String, CodingKey {
        case type
        case source
        case cacheControl = "cache_control"
    }

    public init(
        source: AnthropicImageBlockParamSource,
        cacheControl: AnthropicCacheControlEphemeral? = nil
    ) {
        self.source = source
        self.cacheControl = cacheControl
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("image", forKey: .type)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}
