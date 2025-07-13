//
//  OpenRouterDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/24.
//

import Foundation

open class OpenRouterDirectService: OpenRouterService, DirectService {
    private let unprotectedAPIKey: String
    private let baseURL: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openRouterDirectService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String, baseURL: String? = nil) {
        self.unprotectedAPIKey = unprotectedAPIKey
        self.baseURL = baseURL ?? "https://openrouter.ai"
    }

    /// Initiates a non-streaming chat completion request to /api/v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenRouter through AIProxy. See this reference:
    ///   https://openrouter.ai/docs/requests
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    public func chatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenRouterChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/api/v1/chat/completions",
            body: body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to /api/v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenRouter through AIProxy. See this reference:
    ///   https://openrouter.ai/docs/requests
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///
    /// - Returns: The response body from OpenRouter. See this reference:
    ///            https://openrouter.ai/docs/responses
    public func streamingChatCompletionRequest(
        body: OpenRouterChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<OpenRouterChatCompletionChunk, Error> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/api/v1/chat/completions",
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
}

