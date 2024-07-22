//  AIProxy.swift
//  Created by Lou Zell on 6/12/24.

import Foundation

private let legacyURL = "http://Lous-MacBook-Air-3.local:4000"
private let aiproxyChatPath = "/v1/chat/completions"


public final class OpenAIService {
    private let secureDelegate = AIProxyCertificatePinningDelegate()
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
    ///   - chatRequestBody: The request body to send to aiproxy and openai. See this reference:
    ///                      https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> OpenAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let session = self.getServiceSession()
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: try JSONEncoder().encode(body),
            path: "/v1/chat/completions",
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
    ///   - chatRequestBody: The request body to send to aiproxy and openai. See this reference:
    ///                      https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let session = self.getServiceSession()
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: try JSONEncoder().encode(body),
            path: "/v1/chat/completions",
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
        let session = self.getServiceSession()
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: try JSONEncoder().encode(body),
            path: "/v1/images/generations",
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
        let session = self.getServiceSession()
        let boundary = UUID().uuidString
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: formEncode(body, boundary),
            path: "/v1/audio/transcriptions",
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

        return try JSONDecoder().decode(OpenAICreateTranscriptionResponseBody.self, from: data)
    }


    private func getServiceSession() -> URLSession {
        if (self.serviceURL ?? legacyURL).starts(with: "http://localhost") {
            return URLSession(configuration: .default)
        }
        return URLSession(
            configuration: .default,
            delegate: self.secureDelegate,
            delegateQueue: nil
        )
    }
}

// MARK: - Private Helpers

/// Builds and AI Proxy request.
/// Used for both streaming and non-streaming chat.
private func buildAIProxyRequest(
    partialKey: String,
    serviceURL: String?,
    clientID: String?,
    postBody: Data,
    path: String,
    contentType: String
) async throws -> URLRequest {
    let deviceCheckToken = await AIProxyDeviceCheck.getToken()
    let clientID = clientID ?? AIProxyIdentifier.getClientID()
    let baseURL = serviceURL ?? legacyURL

    guard var urlComponents = URLComponents(string: baseURL) else {
        throw AIProxyError.assertion(
            "Could not create urlComponents, please check the aiproxyEndpoint constant"
        )
    }

    urlComponents.path = urlComponents.path.appending(path)
    guard let url = urlComponents.url else {
        throw AIProxyError.assertion("Could not create a request URL")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postBody
    request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    request.addValue(partialKey, forHTTPHeaderField: "aiproxy-partial-key")

    if let clientID = clientID {
        request.addValue(clientID, forHTTPHeaderField: "aiproxy-client-id")
    }

    if let deviceCheckToken = deviceCheckToken {
        request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
    }

#if DEBUG && targetEnvironment(simulator)
    if let deviceCheckBypass = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"] {
        request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
    }
#endif

    return request
}
