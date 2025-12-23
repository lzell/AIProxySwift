//
//  OpenAIImageGenToolCallResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ImageGenToolCall, version 2.3.0, line 10909

/// An image generation request made by the model.
nonisolated public struct OpenAIImageGenToolCallResource: Decodable, Sendable {
    /// The unique ID of the image generation call.
    public let id: String

    /// The generated image encoded in base64.
    public let result: String?

    /// The status of the image generation call.
    public let status: OpenAIImageGenToolCallStatus

    /// The type of the image generation call. Always `image_generation_call`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case id
        case result
        case status
        case type
    }
}

/// The status of an image generation tool call.
nonisolated public enum OpenAIImageGenToolCallStatus: String, Decodable, Sendable {
    case completed
    case failed
    case generating
    case inProgress = "in_progress"
}
