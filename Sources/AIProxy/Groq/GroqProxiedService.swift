//
//  GroqProxiedService.swift
//
//
//  Created by Lou Zell on 9/29/24.
//

import Foundation

open class GroqProxiedService: GroqService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.groqService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a non-streaming chat completion request to Groq
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#chat-create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: GroqChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> GroqChatCompletionResponseBody {
        var body = body
        body.stream = false
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/openai/v1/chat/completions",
            body:  try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to Groq.
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#chat-create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    public func streamingChatCompletionRequest(
        body: GroqChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<GroqChatCompletionStreamingChunk, Error> {
        var body = body
        body.stream = true
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/openai/v1/chat/completions",
            body:  try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }

    /// Initiates a transcription request to /openai/v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The audio transcription request body. See this reference:
    ///           https://console.groq.com/docs/api-reference#audio-transcription
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    public func createTranscriptionRequest(
        body: GroqTranscriptionRequestBody,
        secondsToWait: UInt
    ) async throws -> GroqTranscriptionResponseBody {
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/openai/v1/audio/transcriptions",
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )

        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
             request
        )
        if (body.responseFormat == "text") {
            guard let text = String(data: data, encoding: .utf8) else {
                throw AIProxyError.assertion("Could not represent OpenAI's whisper response as string")
            }
            return GroqTranscriptionResponseBody(duration: nil, language: nil, segments: nil, text: text, words: nil)
        }
        return try GroqTranscriptionResponseBody.deserialize(from: data)
    }
}
