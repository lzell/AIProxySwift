//
//  MistralDirectService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

open class MistralDirectService: MistralService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.mistralDirectService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming chat completion request to Mistral
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: A ChatCompletionResponse.
    public func chatCompletionRequest(
        body: MistralChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> MistralChatCompletionResponseBody {
        var body = body
        body.stream = false
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.mistral.ai",
            path: "/v1/chat/completions",
            body:  try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to Mistral.
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    public func streamingChatCompletionRequest(
        body: MistralChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<MistralChatCompletionStreamingChunk, Error> {
        var body = body
        body.stream = true
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.mistral.ai",
            path: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }

    /// Initiates an OCR request to Mistral
    ///
    /// - Parameters:
    ///   - body: The OCR request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/ocr/operation/ocr_v1_ocr_post
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: The OCR result
    public func ocrRequest(
        body: MistralOCRRequestBody,
        secondsToWait: UInt
    ) async throws -> MistralOCRResponseBody {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.mistral.ai",
            path: "/v1/ocr",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
