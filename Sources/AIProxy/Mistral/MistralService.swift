//
//  MistralService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

public protocol MistralService {
    /// Initiates a non-streaming chat completion request to Mistral
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    /// - Returns: A ChatCompletionResponse.
    func chatCompletionRequest(
        body: MistralChatCompletionRequestBody
    ) async throws -> MistralChatCompletionResponseBody

    /// Initiates a streaming chat completion request to Mistral.
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    func streamingChatCompletionRequest(
        body: MistralChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, MistralChatCompletionStreamingChunk>
}
