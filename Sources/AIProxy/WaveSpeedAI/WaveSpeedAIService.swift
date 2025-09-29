//
//  WaveSpeedAIService.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

import Foundation

@AIProxyActor public class WaveSpeedAIService: Sendable {
    private let requestBuilder: AIProxyRequestBuilder
    private let serviceNetworker: ServiceMixin

    /// This designated initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.waveSpeedAIService` or `AIProxy.directWaveSpeedAIService` defined in AIProxy.swift.
    nonisolated init(
        requestBuilder: AIProxyRequestBuilder,
        serviceNetworker: ServiceMixin
    ) {
        self.requestBuilder = requestBuilder
        self.serviceNetworker = serviceNetworker
    }

    /// Initiates a request to /api/v3/alibaba/wan-2.5/text-to-image
    ///
    /// - Parameters:
    ///   - body: The request body to send to WaveSpeedAI. See this reference:
    ///           https://wavespeed.ai/models/alibaba/wan-2.5/text-to-image
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: A response body that contains a `requestID` to make polling requests with
    public func runWan25TextToImage(
        body: WaveSpeedAIWan25TextToImageRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIChatCompletionResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: "/api/v3/alibaba/wan-2.5/text-to-image",
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

//    /// Initiates a request to /api/v3/alibaba/wan-2.5/image-to-video-fast
//    ///
//    /// - Parameters:
//    ///   - body: The request body to send to WaveSpeedAI. See this reference:
//    ///           https://wavespeed.ai/models/alibaba/wan-2.5/image-to-video-fast
//    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
//    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
//    /// - Returns: A response body that contains a `requestID` to make polling requests with
//    public func runWan25ImageToVideoFast(
//        body: WaveSpeedAIWan25ImageToVideoFastRequestBody,
//        secondsToWait: UInt,
//        additionalHeaders: [String: String] = [:]
//    ) async throws -> OpenAIChatCompletionResponseBody {
//        var body = body
//        body.stream = false
//        body.streamOptions = nil
//        let request = try await self.requestBuilder.jsonPOST(
//            path: self.resolvedPath("chat/completions"),
//            body: body,
//            secondsToWait: secondsToWait,
//            additionalHeaders: additionalHeaders
//        )
//        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
//    }
}
