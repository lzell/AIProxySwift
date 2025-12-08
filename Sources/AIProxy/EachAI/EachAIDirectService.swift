//
//  EachAIDirectService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

@AIProxyActor public final class EachAIDirectService: EachAIService, DirectService, Sendable {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directEachAIService` defined in AIProxy.swift
    nonisolated init(
        unprotectedAPIKey: String
    ) {
        let requestBuilder = AIProxyDirectRequestBuilder(
            baseURL: "https://flows.eachlabs.ai", // EachAI has different baseURLs depending on which functionality you want to use.
            unprotectedAuthHeader: (key: "X-API-Key", value: unprotectedAPIKey)
        )
        super.init(
            requestBuilder: requestBuilder,
            serviceNetworker: DirectServiceNetworker()
        )
    }
}
