//
//  GroqService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

public protocol GroqService {
    /// Initiates a non-streaming chat completion request to Groq
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#chat-create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    func chatCompletionRequest(
        body: GroqChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> GroqChatCompletionResponseBody

    /// Initiates a streaming chat completion request to Groq.
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#chat-create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    func streamingChatCompletionRequest(
        body: GroqChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<GroqChatCompletionStreamingChunk, Error>

    /// Initiates a transcription request to /openai/v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The audio transcription request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#audio-transcription
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    func createTranscriptionRequest(
        body: GroqTranscriptionRequestBody,
        secondsToWait: UInt
    ) async throws -> GroqTranscriptionResponseBody
}
