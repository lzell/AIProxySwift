//
//  DeepSeekDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/27/25.
//

import Foundation

open class DeepSeekDirectService: DeepSeekService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directDeepSeekService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek. See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    /// - Returns: The chat response. See this reference:
    ///            https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func chatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody
    ) async throws -> DeepSeekChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.deepseek.com",
            path: "/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek.  See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    /// - Returns: An async sequence of completion chunks. See the 'Streaming' tab here:
    ///           https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func streamingChatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, DeepSeekChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.deepseek.com",
            path: "/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
