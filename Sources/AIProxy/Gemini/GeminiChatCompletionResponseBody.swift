//
//  GeminiChatCompletionResponseBody.swift
//
//
//  Created by Todd Hamilton on 10/14/24.
//

import Foundation

public struct GeminiChatCompletionResponseBody: Decodable {
    /// A list of content generation candidates.
    public let candidates: [GeminiCandidate]

    /// Feedback about the prompt, including safety ratings and any block reasons.
    public let promptFeedback: GeminiPromptFeedback?

    /// Metadata related to token usage.
    public let usageMetadata: GeminiUsageMetadata?
}

// MARK: - GeminiCandidate
public struct GeminiCandidate: Decodable {
    /// Placeholder for the candidate object.
    /// You can expand this to include candidate properties based on actual API response structure.
    public let content: String  // Example property for generated content.
}

// MARK: - GeminiPromptFeedback
public struct GeminiPromptFeedback: Decodable {
    /// The reason content was blocked, if applicable.
    public let blockReason: BlockReason?

    /// Safety ratings associated with the response.
    public let safetyRatings: [GeminiSafetyRating]?
}

// MARK: - GeminiSafetyRating
public struct GeminiSafetyRating: Decodable {
    /// Placeholder for the safety rating object.
    /// You can expand this to include safety rating properties based on actual API response structure.
    public let category: String  // Example property for safety category.
    public let score: Int        // Example property for safety score.
}

// MARK: - GeminiUsageMetadata
public struct GeminiUsageMetadata: Decodable {
    /// Number of tokens used by the prompt.
    public let promptTokenCount: Int?

    /// Number of tokens retrieved from cached content, if applicable.
    public let cachedContentTokenCount: Int?

    /// Number of tokens used by the candidates.
    public let candidatesTokenCount: Int?

    /// Total number of tokens used during the request.
    public let totalTokenCount: Int?
}

// MARK: - BlockReason Enum
public enum BlockReason: String, Decodable {
    case unsafeContent = "UNSAFE_CONTENT"
    case policyViolation = "POLICY_VIOLATION"
    case unknown = "UNKNOWN"
}