//  AIProxy.swift
//  Created by Lou Zell on 6/12/24.

import Foundation

private let aiproxyURL = "https://api.aiproxy.pro"
private let aiproxyChatPath = "/v1/chat/completions"


public final class OpenAIService {
    private let secureDelegate = AIProxyCertificatePinning.SecureURLSessionDelegate()
    private let partialKey: String
    private let clientID: String?
    private let deviceCheckBypass: String? = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"]

    /// Creates an instance of OpenAIService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    internal init(partialKey: String, clientID: String?) {
        self.partialKey = partialKey
        self.clientID = clientID
    }

    /// Initiates an async/await-based, non-streaming chat completion request to /v1/chat/completions.
    /// See the usage instructions at the top of this file.
    ///
    /// - Parameters:
    ///   - chatRequestBody: The request body to send to aiproxy and openai. See this reference:
    ///                      https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> OpenAIChatCompletionResponseBody {
        let session = URLSession(configuration: .default,
                                 delegate: self.secureDelegate,
                                 delegateQueue: nil)
        session.sessionDescription = "AIProxy Buffered" // See "Analyze HTTP traffic in Instruments" wwdc session
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            clientID: self.clientID,
            deviceCheckBypass: self.deviceCheckBypass,
            requestBody: body,
            path: "/v1/chat/completions"
        )
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            fatalError("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(statusCode: httpResponse.statusCode,
                                                   responseBody: String(data: data, encoding: .utf8))
        }

        return try JSONDecoder().decode(OpenAIChatCompletionResponseBody.self, from: data)
    }
}

// MARK: - Private Helpers

/// Builds and AI Proxy request.
/// Used for both streaming and non-streaming chat.
private func buildAIProxyRequest(
    partialKey: String,
    clientID: String?,
    deviceCheckBypass: String?,
    requestBody: Encodable,
    path: String
) async throws -> URLRequest {

    let postBody = try JSONEncoder().encode(requestBody)
    let deviceCheckToken = await AIProxyDeviceCheck.getToken()
    let clientID = clientID ?? AIProxyIdentifier.getClientID()

    guard var urlComponents = URLComponents(string: aiproxyURL) else {
        throw AIProxyError.assertion(
            "Could not create urlComponents, please check the aiproxyEndpoint constant"
        )
    }

    urlComponents.path = path
    guard let url = urlComponents.url else {
        throw AIProxyError.assertion("Could not create a request URL")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postBody
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(partialKey, forHTTPHeaderField: "aiproxy-partial-key")

    if let clientID = clientID {
        request.addValue(clientID, forHTTPHeaderField: "aiproxy-client-id")
    }

    if let deviceCheckToken = deviceCheckToken {
        request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
    }

    if let deviceCheckBypass = deviceCheckBypass {
        request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
    }

    return request
}
