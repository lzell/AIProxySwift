//
//  AnthropicMessageParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// For backwards-compat with SDK versions <= "0.134.0"
public typealias AnthropicInputMessage = AnthropicMessageParam

/// An input message in a conversation.
///
/// Our models are trained to operate on alternating `user` and `assistant` conversational turns.
/// When creating a new `Message`, you specify the prior conversational turns with the `messages`
/// parameter, and the model then generates the next `Message` in the conversation. Consecutive
/// `user` or `assistant` turns in your request will be combined into a single turn.
///
/// Each input message must be an object with a `role` and `content`. You can specify a single
/// `user`-role message, or you can include multiple `user` and `assistant` messages.
///
/// If the final message uses the `assistant` role, the response content will continue immediately
/// from the content in that message. This can be used to constrain part of the model's response.
///
/// Example with a single `user` message:
/// ```json
/// [{"role": "user", "content": "Hello, Claude"}]
/// ```
///
/// Example with multiple conversational turns:
/// ```json
/// [
///   {"role": "user", "content": "Hello there."},
///   {"role": "assistant", "content": "Hi, I'm Claude. How can I help you?"},
///   {"role": "user", "content": "Can you explain LLMs in plain English?"}
/// ]
/// ```
///
/// Note that if you want to include a system prompt, you can use the top-level `system` parameter
/// — there is no `"system"` role for input messages in the Messages API.
///
/// There is a limit of 100,000 messages in a single request.
///
/// Represents Anthropic's `MessageParam` object:
/// https://console.anthropic.com/docs/en/api/messages#message_param
nonisolated public struct AnthropicMessageParam: Encodable, Sendable {
    /// The content of the message as an array of content blocks.
    public let content: AnthropicMessageParamContent

    /// The role of the message author.
    public let role: AnthropicRole

    private enum CodingKeys: String, CodingKey {
        case content
        case role
    }

    public init(
        content: AnthropicMessageParamContent,
        role: AnthropicRole
    ) {
        self.content = content
        self.role = role
    }
}
