//
//  DeepSeekService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/27/25.
//

import Foundation

public protocol DeepSeekService {

    /// Initiates a non-streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek. See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    /// - Returns: The chat response. See this reference:
    ///            https://api-docs.deepseek.com/api/create-chat-completion#responses
    func chatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody
    ) async throws -> DeepSeekChatCompletionResponseBody

    /// Initiates a streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek.  See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    /// - Returns: An async sequence of completion chunks. See the 'Streaming' tab here:
    ///           https://api-docs.deepseek.com/api/create-chat-completion#responses
    func streamingChatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, DeepSeekChatCompletionChunk>
}
