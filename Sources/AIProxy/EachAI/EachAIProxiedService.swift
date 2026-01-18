//
//  EachAIProxiedService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

@AIProxyActor public final class EachAIProxiedService: EachAIService, ProxiedService, Sendable {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.eachAIService` defined in AIProxy.swift
    nonisolated init(
        partialKey: String,
        serviceURL: String,
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
