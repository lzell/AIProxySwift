//
//  TogetherAIService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

public protocol TogetherAIService {
    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and Together.ai. See this reference:
    ///           https://docs.together.ai/reference/completions-1
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    func chatCompletionRequest(
        body: TogetherAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> TogetherAIChatCompletionResponseBody

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and Together.ai. See this reference:
    ///           https://docs.together.ai/reference/completions-1
    /// - Returns: A chat completion response. See the reference above.
    func streamingChatCompletionRequest(
        body: TogetherAIChatCompletionRequestBody
    ) async throws -> AsyncThrowingStream<OpenAIChatCompletionChunk, Error>
}
