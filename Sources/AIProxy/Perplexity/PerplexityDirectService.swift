//
//  PerplexityDirectService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

open class PerplexityDirectService: PerplexityService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.perplexityDirectService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming chat completion request to Perplexity
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///   https://platform.openai.com/docs/api-reference/chat/object
    ///
    /// - Returns: A ChatCompletionResponse
    public func chatCompletionRequest(
        body: PerplexityChatCompletionRequestBody
    ) async throws -> PerplexityChatCompletionResponseBody {
        var body = body
        body.stream = false
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.perplexity.ai",
            path: "/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to Perplexity.
    ///
    /// - Parameters:
    ///
    ///   - body: The chat completion request body. See this reference:
    ///   https://platform.openai.com/docs/api-reference/chat/object
    ///
    /// - Returns: An async sequence of completion chunks.
    public func streamingChatCompletionRequest(
        body: PerplexityChatCompletionRequestBody
    ) async throws -> AsyncThrowingStream<PerplexityChatCompletionResponseBody, Error> {
        var body = body
        body.stream = true
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.perplexity.ai",
            path: "/chat/completions",
            body:  try body.serialize(),
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
