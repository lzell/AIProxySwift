//
//  EachAIProxiedService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

open class EachAIProxiedService: EachAIService, ProxiedService {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.eachAIService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        let requestBuilder = OpenAIProxiedRequestBuilder(
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
