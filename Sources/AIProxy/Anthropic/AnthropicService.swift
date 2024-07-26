//
//  AnthropicService.swift
//
//
//  Created by Lou Zell on 7/25/24.
//

import Foundation

public final class AnthropicService {
    private let secureDelegate = AIProxyCertificatePinningDelegate()
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of OpenAIService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a non-streaming request to /v1/messages.
    ///
    /// - Parameters:
    ///   - messageRequestBody: The request body to send to aiproxy and anthropic. See this reference:
    ///                         https://docs.anthropic.com/en/api/messages
    /// - Returns: The message response, See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func messageRequest(
        body: AnthropicMessageRequestBody
    ) async throws -> AnthropicMessageResponseBody {
        var body = body
        body.stream = false
        let session = self.getServiceSession()
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: try body.safeEncode(),
            path: "/v1/messages",
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
    
        return try AnthropicMessageResponseBody.safeDecode(from: data)
    }

    private func getServiceSession() -> URLSession {
        if self.serviceURL.starts(with: "http://localhost") {
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
    serviceURL: String,
    clientID: String?,
    postBody: Data,
    path: String,
    contentType: String
) async throws -> URLRequest {
    let deviceCheckToken = await AIProxyDeviceCheck.getToken()
    let clientID = clientID ?? AIProxyIdentifier.getClientID()
    let baseURL = serviceURL

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
