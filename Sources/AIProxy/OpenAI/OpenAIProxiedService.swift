//  OpenAIProxiedService.swift
//
//
//  Created by Lou Zell on 12/14/24.
//

@AIProxyActor final class OpenAIProxiedService: OpenAIService, ProxiedService, Sendable {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    nonisolated init(
        partialKey: String,
        serviceURL: String?,
        clientID: String?,
        requestFormat: OpenAIRequestFormat = .standard
    ) {
        let requestBuilder = AIProxyProxiedRequestBuilder(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
        super.init(
            requestFormat: requestFormat,
            requestBuilder: requestBuilder,
            serviceNetworker: OpenAIProxiedServiceNetworker()
        )
    }
}
