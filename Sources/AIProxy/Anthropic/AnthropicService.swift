//
//  AnthropicService.swift
//
//
//  Created by Lou Zell on 12/13/24.
//

import Foundation

@AIProxyActor public class AnthropicService: Sendable {
    private let requestBuilder: AIProxyRequestBuilder
    private let serviceNetworker: ServiceMixin

    /// This designated initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.anthropicService` or `AIProxy.directAnthropicService` defined in AIProxy.swift.
    nonisolated init(
        requestBuilder: AIProxyRequestBuilder,
        serviceNetworker: ServiceMixin
    ) {
        self.requestBuilder = requestBuilder
        self.serviceNetworker = serviceNetworker
    }

    /// Initiates a non-streaming request to /v1/messages.
    ///
    /// - Parameters:
    ///   - body: The message request body. See this reference:
    ///           https://docs.anthropic.com/en/api/messages
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    ///
    /// - Returns: The message response body, See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func messageRequest(
        body: AnthropicMessageRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AnthropicMessage {
        var body = body
        body.stream = false
        var additionalHeaders = additionalHeaders
        additionalHeaders["anthropic-version"] = "2023-06-01"
        let request = try await self.requestBuilder.jsonPOST(
            path: "/v1/messages",
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming request to /v1/messages with tool call accumulation.
    /// Tool calls are buffered internally and emitted as complete chunks, while text deltas are emitted immediately.
    ///
    /// - Parameters:
    ///   - body: The message request body. See this reference:
    ///                         https://docs.anthropic.com/en/api/messages
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    ///
    /// - Returns: An `AnthropicAsyncChunks` sequence that yields text and tool use chunks
    public func streamingMessageRequest(
        body: AnthropicMessageRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<AnthropicStreamingEvent, Error> {
        var body = body
        body.stream = true
        var headers = additionalHeaders
        headers["anthropic-version"] = "2023-06-01"
        let request = try await self.requestBuilder.jsonPOST(
            path: "/v1/messages",
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: headers
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeStreamingChunks(request)
    }
}

// MARK: - Deprecated API

extension AnthropicService {
    @available(*, deprecated, message: "Please use messageRequest(body:secondsToWait:). For parity with your existing call, use 60 as secondsToWait.")
    public func messageRequest(
        body: AnthropicMessageRequestBody
    ) async throws -> AnthropicMessage {
        return try await self.messageRequest(body: body, secondsToWait: 60)
    }

    @available(*, deprecated, message: "Please use streamingMessageRequest(body:secondsToWait:). For parity with your existing call, use 60 as secondsToWait.")
    public func streamingMessageRequest(
        body: AnthropicMessageRequestBody
    ) async throws -> AsyncThrowingStream<AnthropicStreamingEvent, Error> {
        return try await self.streamingMessageRequest(body: body, secondsToWait: 60)
    }
}
