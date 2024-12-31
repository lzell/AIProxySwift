//
//  OpenRouterService.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/24.
//

import Foundation

public protocol OpenRouterService {

    /// Initiates a non-streaming chat completion request to /api/v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenRouter through AIProxy. See this reference:
    ///   https://openrouter.ai/docs/requests
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    func chatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody
    ) async throws -> OpenRouterChatCompletionResponseBody

    /// Initiates a streaming chat completion request to /api/v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenRouter through AIProxy. See this reference:
    ///   https://openrouter.ai/docs/requests
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    func streamingChatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenRouterChatCompletionChunk>
}
