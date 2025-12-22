//
//  OpenAIEasyInputMessage.swift
//
//
//  Created by Lou Zell on 12/19/24.
//
// OpenAPI spec: EasyInputMessage, version 2.3.0, line 40770
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-input_message

/// An input message that can be added to a conversation.
nonisolated public struct OpenAIEasyInputMessage: Encodable, Sendable {
    /// The type of item, always "message".
    public let type: String = "message"

    /// The role of the message input. One of `user`, `assistant`, `system`, or `developer`.
    public let role: OpenAIRole

    /// Text, image, or audio input to the model, used to generate a response.
    /// Can also contain previous assistant responses.
    public let content: OpenAIEasyInputMessageContent

    public init(
        role: OpenAIConversationsRole,
        content: OpenAIConversationsInputContent
    ) {
        self.role = role
        self.content = content
    }
}
