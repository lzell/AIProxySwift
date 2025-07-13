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
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: A ChatCompletionResponse.
    func chatCompletionRequest(
        body: MistralChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> MistralChatCompletionResponseBody

    /// Initiates a streaming chat completion request to Mistral.
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    func streamingChatCompletionRequest(
        body: MistralChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<MistralChatCompletionStreamingChunk, Error>

    /// Initiates an OCR request to Mistral
    ///
    /// - Parameters:
    ///   - body: The OCR request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/ocr/operation/ocr_v1_ocr_post
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: The OCR result
    func ocrRequest(
        body: MistralOCRRequestBody,
        secondsToWait: UInt
    ) async throws -> MistralOCRResponseBody
}
