//
//  AnthropicDirectService.swift
//
//
//  Created by Lou Zell on 12/13/24.
//

import Foundation

open class AnthropicDirectService: AnthropicService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directAnthropicService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Initiates a non-streaming request to /v1/messages.
    ///
    /// - Parameters:
    ///   - body: The message request body. See this reference:
    ///                         https://docs.anthropic.com/en/api/messages
    /// - Returns: The message response body, See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func messageRequest(
        body: AnthropicMessageRequestBody
    ) async throws -> AnthropicMessageResponseBody {
        var body = body
        body.stream = false
        let session = URLSession(configuration: .ephemeral)
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.anthropic.com",
            path: "/v1/messages",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            headers: [
                "x-api-key": self.unprotectedAPIKey,
                "anthropic-version": "2023-06-01"
            ]
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

        return try AnthropicMessageResponseBody.deserialize(from: data)
    }

    /// Initiates a streaming request to /v1/messages.
    ///
    /// - Parameters:
    ///   - body: The message request body. See this reference:
    ///                         https://docs.anthropic.com/en/api/messages
    /// - Returns: The message response body, See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func streamingMessageRequest(
        body: AnthropicMessageRequestBody
    ) async throws -> AnthropicAsyncChunks {
        var body = body
        body.stream = true
        let session = URLSession(configuration: .ephemeral)
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.anthropic.com",
            path: "/v1/messages",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json",
            headers: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
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

        return AnthropicAsyncChunks(asyncLines: asyncBytes.lines)
    }
}

