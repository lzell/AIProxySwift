//
//  FireworksAIProxiedService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/29/25.
//

import Foundation

open class FireworksAIProxiedService: FireworksAIService, ProxiedService {

    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.fireworksAIService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a non-streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI. See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: The chat response. See this reference:
    ///            https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func deepSeekR1Request(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> DeepSeekChatCompletionResponseBody {
        if body.model != "accounts/fireworks/models/deepseek-r1" {
            logIf(.warning)?.warning("Attempting to use deepSeekR1Request with an unknown model")
        }
        var body = body
        body.stream = false
        body.streamOptions = nil
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/inference/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI.  See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See the 'Streaming' tab here:
    ///           https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func streamingDeepSeekR1Request(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<DeepSeekChatCompletionChunk, Error> {
        if body.model != "accounts/fireworks/models/deepseek-r1" {
            logIf(.warning)?.warning("Attempting to use deepSeekR1Request with an unknown model")
        }
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/inference/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
