//
//  AnthropicDirectService.swift
//
//
//  Created by Lou Zell on 12/13/24.
//

import Foundation

open class AnthropicDirectService: AnthropicService, DirectService {
    private let unprotectedAPIKey: String
    private let baseURL: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directAnthropicService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String, baseURL: String? = nil) {
        self.unprotectedAPIKey = unprotectedAPIKey
        self.baseURL = baseURL ?? "https://api.anthropic.com"
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
        var additionalHeaders = [
            "x-api-key": self.unprotectedAPIKey,
            "anthropic-version": "2023-06-01",
        ]
        if body.needsPDFBeta {
            additionalHeaders["anthropic-beta"] = "pdfs-2024-09-25"
        }
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/v1/messages",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: additionalHeaders
        )
        return try await self.makeRequestAndDeserializeResponse(request)
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
        var additionalHeaders = [
            "x-api-key": self.unprotectedAPIKey,
            "anthropic-version": "2023-06-01",
        ]
        if body.needsPDFBeta {
            additionalHeaders["anthropic-beta"] = "pdfs-2024-09-25"
        }
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/v1/messages",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: additionalHeaders
        )
        let (asyncBytes, _) = try await BackgroundNetworker.makeRequestAndWaitForAsyncBytes(self.urlSession, request)
        return AnthropicAsyncChunks(asyncLines: asyncBytes.lines)
    }
}
