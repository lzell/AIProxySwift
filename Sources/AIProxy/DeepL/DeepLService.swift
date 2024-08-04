//
//  DeepLService.swift
//
//
//  Created by Lou Zell on 8/3/24.
//

import Foundation

public final class DeepLService {
    private let secureDelegate = AIProxyCertificatePinningDelegate()
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of DeepL service. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.deepLService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a request to /v2/translate
    ///
    /// - Parameters:
    ///   - body: The translation request. See this reference:
    ///           https://developers.deepl.com/docs/api-reference/translate/openapi-spec-for-text-translation
    /// - Returns: The deserialized response body
    public func translateRequest(
        body: DeepLTranslateRequestBody
    ) async throws -> DeepLTranslateResponseBody {
        let session = self.getServiceSession()
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: try JSONEncoder().encode(body),
            path: "/v2/translate",
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

        return try JSONDecoder().decode(DeepLTranslateResponseBody.self, from: data)
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

