//
//  FireworksAIService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/29/25.
//

import Foundation

public protocol FireworksAIService {

    /// Initiates a non-streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI. See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The number of seconds to wait before timing out
    /// - Returns: The chat response. See this reference:
    ///            https://api-docs.deepseek.com/api/create-chat-completion#responses
    func deepSeekR1Request(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> DeepSeekChatCompletionResponseBody

    /// Initiates a streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI.  See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The number of seconds to wait before timing out
    /// - Returns: An async sequence of completion chunks. See the 'Streaming' tab here:
    ///           https://api-docs.deepseek.com/api/create-chat-completion#responses
    func streamingDeepSeekR1Request(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<DeepSeekChatCompletionChunk, Error>
}
