//
//  OpenAIImageGenerationToolCall.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: ImageGenToolCall, version 2.3.0, line 44630
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-image_generation_call

/// An image generation request made by the model.
nonisolated public struct OpenAIImageGenerationToolCall: Codable, Sendable {
    /// The unique ID of the image generation call.
    public let id: String
    
    /// The generated image encoded in base64.
    public let result: String?
    
    /// The status of the image generation call.
    public let status: Status
    
    /// The type of the image generation call. Always `image_generation_call`.
    public let type = "image_generation_call"
    
    /// Creates a new image generation tool call.
    /// - Parameters:
    ///   - id: The unique ID of the image generation call.
    ///   - result: The generated image encoded in base64.
    ///   - status: The status of the image generation call.
    public init(
        id: String,
        result: String?,
        status: Status
    ) {
        self.id = id
        self.result = result
        self.status = status
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case result
        case status
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(result, forKey: .result)
        try container.encode(status, forKey: .status)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIImageGenerationToolCall {
    /// The status of the image generation call.
    public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case completed
        case generating
        case failed
    }
}
