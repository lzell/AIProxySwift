//  OpenAIProxiedService.swift
//
//
//  Created by Lou Zell on 12/14/24.
//

open class OpenAIProxiedService: OpenAIService, ProxiedService {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openAIService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String?,
        clientID: String?,
        requestFormat: OpenAIRequestFormat = .standard
    ) {
        let requestBuilder = OpenAIProxiedRequestBuilder(
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
