//
//  WaveSpeedAIProxiedService.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

@AIProxyActor final class WaveSpeedAIProxiedService: WaveSpeedAIService, ProxiedService, Sendable {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    nonisolated init(
        partialKey: String,
        serviceURL: String?,
        clientID: String?
    ) {
        let requestBuilder = AIProxyProxiedRequestBuilder(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
        super.init(
            requestBuilder: requestBuilder,
            serviceNetworker: OpenAIProxiedServiceNetworker()
        )
    }
}
