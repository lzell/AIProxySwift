//
//  OpenAIReasoningItem.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: ReasoningItem, version 2.3.0, line 56556
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-reasoning

/// A description of the chain of thought used by a reasoning model while generating a response.
/// Be sure to include these items in your `input` to the Responses API for subsequent turns of a conversation if you are manually managing context.
nonisolated public struct OpenAIReasoningItem: Codable, Sendable {
    /// The unique identifier of the reasoning content.
    public let id: String

    /// Reasoning summary content.
    public let summary: OpenAIReasoningSummaryText

    /// The type of the object. Always `reasoning`.
    public let type = "reasoning"

    /// Reasoning text content.
    public let content: [OpenAIReasoningText]?

    /// The encrypted content of the reasoning item.
    /// Populated when a response is generated with `reasoning.encrypted_content` in the `include` parameter.
    public let encryptedContent: String?

    /// The status of the item. One of `in_progress`, `completed`, or `incomplete`.
    /// Populated when items are returned via API.
    public let status: Status?

    private enum CodingKeys: String, CodingKey {
        case id
        case summary
        case type
        case content
        case encryptedContent = "encrypted_content"
        case status
    }

    public init(
        id: String,
        summary: OpenAIReasoningSummaryText,
        content: [OpenAIReasoningText]? = nil,
        encryptedContent: String? = nil,
        status: OpenAIReasoningItem.Status? = nil
    ) {
        self.id = id
        self.summary = summary
        self.content = content
        self.encryptedContent = encryptedContent
        self.status = status
    }
}

extension OpenAIReasoningItem {
    /// The status of the reasoning item.
    public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
    }
}
