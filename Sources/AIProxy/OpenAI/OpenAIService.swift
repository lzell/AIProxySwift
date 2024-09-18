//  AIProxy.swift
//  Created by Lou Zell on 6/12/24.

import Foundation

private let legacyURL = "https://api.aiproxy.pro"
private let aiproxyChatPath = "/v1/chat/completions"


public final class OpenAIService {
    private let partialKey: String
    private let serviceURL: String?
    private let clientID: String?

    /// Creates an instance of OpenAIService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String?, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> OpenAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: "/chat/completions?api-version=2023-03-15-preview",
            body:  try JSONEncoder().encode(body),
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

        return try JSONDecoder().decode(OpenAIChatCompletionResponseBody.self, from: data)
    }

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: "/chat/completions?api-version=2023-03-15-preview",
            body:  try JSONEncoder().encode(body),
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

    /// Initiates a create image request to /v1/images/generations
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func createImageRequest(
        body: OpenAICreateImageRequestBody
    ) async throws -> OpenAICreateImageResponseBody {
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: "/v1/images/generations",
            body:  try JSONEncoder().encode(body),
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

        return try JSONDecoder().decode(OpenAICreateImageResponseBody.self, from: data)
    }

    /// Initiates a create transcription request to v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createTranscription
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    public func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody
    ) async throws -> OpenAICreateTranscriptionResponseBody {
        let session = AIProxyURLSession.create()
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: "/v1/audio/transcriptions",
            body: formEncode(body, boundary),
            verb: .post,
            contentType: "multipart/form-data; boundary=\(boundary)"
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

        if (body.responseFormat == "text") {
            guard let text = String(data: data, encoding: .utf8) else {
                throw AIProxyError.assertion("Could not represent OpenAI's whisper response as string")
            }
            return OpenAICreateTranscriptionResponseBody(text: text, language: nil, duration: nil, words: nil, segments: nil)
        }

        return try JSONDecoder().decode(OpenAICreateTranscriptionResponseBody.self, from: data)
    }
}
