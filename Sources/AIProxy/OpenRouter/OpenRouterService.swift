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
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    func chatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenRouterChatCompletionResponseBody

    /// Initiates a streaming chat completion request to /api/v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenRouter through AIProxy. See this reference:
    ///   https://openrouter.ai/docs/requests
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    func streamingChatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<OpenRouterChatCompletionChunk, Error>
}

extension OpenRouterService {
    public func chatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody
    ) async throws -> OpenRouterChatCompletionResponseBody {
        return try await self.chatCompletionRequest(body: body, secondsToWait: 60)
    }

    public func streamingChatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody
    ) async throws -> AsyncThrowingStream<OpenRouterChatCompletionChunk, Error> {
        return try await self.streamingChatCompletionRequest(body: body, secondsToWait: 60)
    }
}
