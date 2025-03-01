//
//  DeepSeekDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/27/25.
//

import Foundation

open class DeepSeekDirectService: DeepSeekService, DirectService {
    private let unprotectedAPIKey: String
    private let baseURL: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directDeepSeekService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String,
        baseURL: String? = nil
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
        
        let DEFAULT_BASE_URL = "https://api.deepseek.com"
        if let baseURL = baseURL {
            self.baseURL = baseURL.isEmpty ? DEFAULT_BASE_URL : baseURL
        } else {
            self.baseURL = DEFAULT_BASE_URL
        }
    }

    /// Initiates a non-streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek. See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: The chat response. See this reference:
    ///            https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func chatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: Int
    ) async throws -> DeepSeekChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        var request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        request.timeoutInterval = TimeInterval(secondsToWait)
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to /chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to DeepSeek.  See this reference:
    ///           https://api-docs.deepseek.com/api/create-chat-completion
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See the 'Streaming' tab here:
    ///           https://api-docs.deepseek.com/api/create-chat-completion#responses
    public func streamingChatCompletionRequest(
        body: DeepSeekChatCompletionRequestBody,
        secondsToWait: Int
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, DeepSeekChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        var request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "Accept": "application/json"
            ]
        )
        request.timeoutInterval = TimeInterval(secondsToWait)
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }
}
