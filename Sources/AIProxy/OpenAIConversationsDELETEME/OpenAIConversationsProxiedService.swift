//
//  OpenAIConversationsProxiedService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

@AIProxyActor final class OpenAIConversationsProxiedService: OpenAIConversationsService, ProxiedService, Sendable {

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openaiConversationsService` defined in AIProxy.swift
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
