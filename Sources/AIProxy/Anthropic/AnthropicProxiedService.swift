//
//  AnthropicService.swift
//
//
//  Created by Lou Zell on 7/25/24.
//

import Foundation

@AIProxyActor final class AnthropicProxiedService: AnthropicService, ProxiedService, Sendable {

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.anthropicService` defined in AIProxy.swift
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
            serviceNetworker: ProxiedServiceNetworker()
        )
    }
}
