//
//  PerplexityService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

public protocol PerplexityService {
    /// Initiates a non-streaming chat completion request to Perplexity
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///   https://platform.openai.com/docs/api-reference/chat/object
    ///
    /// - Returns: A ChatCompletionResponse
    func chatCompletionRequest(
        body: PerplexityChatCompletionRequestBody
    ) async throws -> PerplexityChatCompletionResponseBody

    /// Initiates a streaming chat completion request to Perplexity.
    ///
    /// - Parameters:
    ///
    ///   - body: The chat completion request body. See this reference:
    ///   https://platform.openai.com/docs/api-reference/chat/object
    ///
    /// - Returns: An async sequence of completion chunks.
    func streamingChatCompletionRequest(
        body: PerplexityChatCompletionRequestBody
    ) async throws -> AsyncThrowingStream<PerplexityChatCompletionResponseBody, Error>
}
