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

    #if false
    public func callPredictAndPoll(
        path: String,
        body: any Encodable,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws {
        let request = try await self.requestBuilder.jsonPOST(
            path: path,
            body: body,
            secondsToWait: 60,
        )
        let pred: WaveSpeedAICreatePredictionResponseBody = try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
        if pred.data?.status == "completed" {
            // Return it right here! Don't go into poll loop.
        }
        guard let getURL = pred.data?.urls?.get else {
            throw WaveSpeedAIError.predictionDidNotIncludeURL
        }

        try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response: WaveSpeedAICreatePredictionResponseBody = try await self.getPrediction(
                url: url
            )
            if response.status?.isTerminal == true {
                return response
            }
            try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        }
        throw WaveSpeedAIError.reachedRetryLimit
    }

    public func getPrediction(url: URL) {

        guard url.host == "api.wavespeed.ai" else {
            // 
            throw AIProxyError.assertion("Replicate has changed the poll domain")

        }

        guard url.host == "api.replicate.com" else {
            throw AIProxyError.assertion("Replicate has changed the poll domain")
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: url.path,
            body: nil,
            verb: .get,
            secondsToWait: 60
        )
        return try await self.makeRequestAndDeserializeResponse(request)


    }

    public func pollForPredictionCompletion<Output: Decodable & Sendable>(
        url: URL,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> ReplicatePrediction<Output> {
        try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response: ReplicatePrediction<Output> = try await self.getPrediction(
                url: url
            )
            if response.status?.isTerminal == true {
                return response
            }
            try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        }
        throw ReplicateError.reachedRetryLimit
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
    ) async throws -> WaveSpeedAICreatePredictionResponseBody {
        self.callPredictAndPoll(path: "/api/v3/alibaba/wan-2.5/text-to-image", body: body)
        let request = try await self.requestBuilder.jsonPOST(
            path: "foo",
            body: body,
            secondsToWait: secondsToWait
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
    #endif
}
