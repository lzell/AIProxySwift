//
//  AnthropicImageMediaType.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

nonisolated public enum AnthropicImageMediaType: String, Encodable, Sendable {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case webp = "image/webp"
}
