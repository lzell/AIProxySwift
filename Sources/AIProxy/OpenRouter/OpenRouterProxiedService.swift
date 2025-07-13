//
//  OpenRouterProxiedService.swift
//  AIProxy
//
//  Created by Lou Zell on 12/30/24.
//

import Foundation

open class OpenRouterProxiedService: OpenRouterService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openRouterService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}

