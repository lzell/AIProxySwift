//
//  StabilityAIService.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

import Foundation

public final class StabilityAIService {
    private let secureDelegate = AIProxyCertificatePinningDelegate()
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of StabilityAI service. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.stabilityAIService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a request to /v2beta/stable-image/generate/ultra
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and StabilityAI. See this reference:
    ///           https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post
    /// - Returns: The response as StabilityAIUltraResponse, wth image binary data stored on
    ///            the `imageData` property
    public func ultraRequest(
        body: StabilityAIUltraRequestBody
    ) async throws -> StabilityAIUltraResponse {
        let session = self.getServiceSession()
        let boundary = UUID().uuidString
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            postBody: formEncode(body, boundary),
            path: "/v2beta/stable-image/generate/ultra",
            contentType: "multipart/form-data; boundary=\(boundary)",
            accept: "image/*"
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

        return StabilityAIUltraResponse(
            imageData: data,
            contentType: httpResponse.allHeaderFields["Content-Type"] as? String,
            finishReason: httpResponse.allHeaderFields["finish-reason"] as? String,
            seed: httpResponse.allHeaderFields["seed"] as? String
        )
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
    contentType: String,
    accept: String
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
    request.addValue(accept, forHTTPHeaderField: "Accept")
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
