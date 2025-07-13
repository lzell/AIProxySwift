//
//  FireworksAIDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/29/25.
//

import Foundation

open class FireworksAIDirectService: FireworksAIService, DirectService {

    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directFireworksAIService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI. See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The number of seconds to wait before timing out
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.fireworks.ai",
            path: "/inference/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to DeepSeek R1 at api.fireworks.ai/inference/v1/chat/completions
    ///
    /// - Parameters:
    ///   - body: The request body to send to FireworksAI.  See these references:
    ///           https://fireworks.ai/models/fireworks/deepseek-r1
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The number of seconds to wait before timing out
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.fireworks.ai",
            path: "/inference/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
   }
}
