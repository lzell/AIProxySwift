//
//  OpenAIReasoningItemResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ReasoningItem, version 2.3.0, line 14477

/// A description of the chain of thought used by a reasoning model while generating a response.
///
/// Be sure to include these items in your `input` to the Responses API for subsequent turns of a conversation
/// if you are manually [managing context](https://platform.openai.com/docs/guides/conversation-state).
nonisolated public struct OpenAIReasoningItemResource: Decodable, Sendable {
    /// The unique identifier of the reasoning content.
    public let id: String

    /// Reasoning summary content.
    public let summary: [OpenAIReasoningSummary]

    /// The type of the object. Always `reasoning`.
    public let type: String

    /// Reasoning text content.
    public let content: [OpenAIReasoningTextContentResource]?

    /// The encrypted content of the reasoning item.
    ///
    /// Populated when a response is generated with `reasoning.encrypted_content` in the `include` parameter.
    public let encryptedContent: String?

    /// The status of the item.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when items are returned via API.
    public let status: OpenAIReasoningItemStatus?

    private enum CodingKeys: String, CodingKey {
        case id
        case summary
        case type
        case content
        case encryptedContent = "encrypted_content"
        case status
    }
}

/// The status of a reasoning item.
nonisolated public enum OpenAIReasoningItemStatus: String, Decodable, Sendable {
    case completed
    case inProgress = "in_progress"
    case incomplete
}

/// A summary text from the model.
nonisolated public struct OpenAIReasoningSummary: Decodable, Sendable {
    /// A summary of the reasoning output from the model so far.
    public let text: String

    /// The type of the object. Always `summary_text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}
