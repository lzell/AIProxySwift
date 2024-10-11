//
//  TogetherAIService.swift
//
//
//  Created by Lou Zell on 8/14/24.
//

import Foundation

/// AIProxy's swift client for Together.ai
public final class TogetherAIService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of TogetherAIService. Note that the initializer is not public.
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
        body: TogetherAIChatCompletionRequestBody
    ) async throws -> TogetherAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.createHTTP(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json"
        )
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }
        
        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try TogetherAIChatCompletionResponseBody.deserialize(from: data)
    }

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and Together.ai. See this reference:
    ///           https://docs.together.ai/reference/completions-1
    /// - Returns: A chat completion response. See the reference above.
    public func streamingChatCompletionRequest(
        body: TogetherAIChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk> {
        var body = body
        body.stream = true

        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.createHTTP(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/chat/completions",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json"
        )

        let (asyncBytes, res) = try await session.bytes(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            let responseBody = try await asyncBytes.lines.reduce(into: "") { $0 += $1 }
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: responseBody
            )
        }

        return asyncBytes.lines.compactMap { OpenAIChatCompletionChunk.from(line: $0) }
    }
}
