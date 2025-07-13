//
//  PerplexityProxiedService.swift
//
//
//  Created by Lou Zell on 11/06/24.
//

import Foundation

open class PerplexityProxiedService: PerplexityService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.perplexityService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/chat/completions",
            body:  try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/chat/completions",
            body:  try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
