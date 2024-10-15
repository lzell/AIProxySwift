//
//  GeminiChatCompletionResponseBody.swift
//
//
//  Created by Todd Hamilton on 10/14/24.
//

import Foundation

/// Format taken from here:
/// https://ai.google.dev/api/generate-content#generatecontentresponse
public struct GeminiGenerateContentResponseBody: Decodable {
    public let candidates: [GeminiCandidate]
    public let usageMetadata: GeminiUsageMetadata
}

/// Candidate responses from the model.
public struct GeminiCandidate: Decodable {
    public let content: GeminiContent
    public let finishReason: String
    public let index: Int
    public let safetyRatings: [GeminiSafetyRating]
}

/// Generated content returned from the model.
public struct GeminiContent: Decodable {
    public let parts: [GeminiPart]
    public let role: String
}

public struct GeminiPart: Decodable {
    public let text: String
}

/// Ratings for safety of the prompt. There is at most one rating per category.
public struct GeminiSafetyRating: Decodable {
    public let category: String
    public let probability: String
}

/// Metadata on the generation request's token usage.
public struct GeminiUsageMetadata: Decodable {
    public let promptTokenCount: Int
    public let candidatesTokenCount: Int
    public let totalTokenCount: Int
}