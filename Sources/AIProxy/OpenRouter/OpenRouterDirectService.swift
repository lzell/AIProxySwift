//
//  OpenRouterDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/24.
//

import Foundation

open class OpenRouterDirectService: OpenRouterService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openRouterDirectService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String) {
        self.unprotectedAPIKey = unprotectedAPIKey
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
        secondsToWait: Int
    ) async throws -> OpenRouterChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        var request = try AIProxyURLRequest.createDirect(
            baseURL: "https://openrouter.ai",
            path: "/api/v1/chat/completions",
            body: body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        request.timeoutInterval = TimeInterval(secondsToWait)
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
        secondsToWait: Int
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenRouterChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        var request = try AIProxyURLRequest.createDirect(
            baseURL: "https://openrouter.ai",
            path: "/api/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        request.timeoutInterval = TimeInterval(secondsToWait)
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}

