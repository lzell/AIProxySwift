//
//  StabilityAIDirectService.swift
//  
//
//  Created by Lou Zell on 12/15/24.
//

import Foundation

@AIProxyActor final class StabilityAIDirectService: StabilityAIService, DirectService, Sendable {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directStabilityAIService` defined in AIProxy.swift
    nonisolated init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
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
        return try await self.stabilityRequestCommon(
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
        return try await self.stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/generate/sd3"
        )
    }

    public func stabilityRequestCommon<T: MultipartFormEncodable>(
        body: T,
        path: String
    ) async throws -> StabilityAIImageResponse {
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.stability.ai",
            path: path,
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: 60,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "Accept": "image/*",
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        let (data, httpResponse) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return StabilityAIImageResponse(
            imageData: data,
            contentType: httpResponse.allHeaderFields["Content-Type"] as? String,
            finishReason: httpResponse.allHeaderFields["finish-reason"] as? String,
            seed: httpResponse.allHeaderFields["seed"] as? String
        )
    }
}
