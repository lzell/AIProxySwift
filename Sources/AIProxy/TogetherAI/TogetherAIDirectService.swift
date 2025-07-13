//
//  TogetherAIDirectService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

open class TogetherAIDirectService: TogetherAIService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.togetherAIDirectService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and Together.ai. See this reference:
    ///           https://docs.together.ai/reference/completions-1
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: TogetherAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> TogetherAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.together.xyz",
            path: "/v1/chat/completions",
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

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and Together.ai. See this reference:
    ///           https://docs.together.ai/reference/completions-1
    /// - Returns: A chat completion response. See the reference above.
    public func streamingChatCompletionRequest(
        body: TogetherAIChatCompletionRequestBody
    ) async throws -> AsyncThrowingStream<OpenAIChatCompletionChunk, Error> {
        var body = body
        body.stream = true
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.together.xyz",
            path: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
