//
//  WaveSpeedAIDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

@AIProxyActor final class WaveSpeedAIDirectService: WaveSpeedAIService, DirectService, Sendable {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directWaveSpeedAIService` defined in AIProxy.swift
    nonisolated init(
        unprotectedAPIKey: String,
        baseURL: String? = nil
    ) {
        let baseURL = baseURL ?? "https://api.wavespeed.ai"
        let requestBuilder = AIProxyDirectRequestBuilder(
            baseURL: baseURL,
            unprotectedAuthHeader: (key: "Authorization", value: "Bearer \(unprotectedAPIKey)")
        )
        super.init(
            requestBuilder: requestBuilder,
            serviceNetworker: OpenAIDirectServiceNetworker()
        )
    }
}
