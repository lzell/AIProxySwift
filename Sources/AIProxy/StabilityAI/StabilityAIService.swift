//
//  StabilityAIService.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

import Foundation

public final class StabilityAIService {
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
    ) async throws -> StabilityAIImageResponse {
        return try await stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/generate/ultra"
        )
    }

    /// Initiates a request to /v2beta/stable-image/generate/sd3
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and StabilityAI. See this reference:
    ///           https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post
    /// - Returns: The response as StabilityAIUltraResponse, wth image binary data stored on
    ///            the `imageData` property
    public func stableDiffusionRequest(
        body: StabilityAIStableDiffusionRequestBody
    ) async throws -> StabilityAIImageResponse {
        return try await stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/generate/sd3"
        )
    }

    private func stabilityRequestCommon<T: MultipartFormEncodable>(
        body: T,
        path: String
    ) async throws -> StabilityAIImageResponse {
        let session = AIProxyURLSession.create()
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: path,
            body: formEncode(body, boundary),
            verb: .post,
            contentType: "multipart/form-data; boundary=\(boundary)",
            headers: ["Accept": "image/*"]
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

        return StabilityAIImageResponse(
            imageData: data,
            contentType: httpResponse.allHeaderFields["Content-Type"] as? String,
            finishReason: httpResponse.allHeaderFields["finish-reason"] as? String,
            seed: httpResponse.allHeaderFields["seed"] as? String
        )
    }
}
