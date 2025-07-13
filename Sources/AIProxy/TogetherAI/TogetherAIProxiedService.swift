//
//  TogetherAIService.swift
//
//
//  Created by Lou Zell on 8/14/24.
//

import Foundation

open class TogetherAIProxiedService: TogetherAIService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.togetherAIService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
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
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
