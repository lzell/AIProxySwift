//
//  EachAIDirectService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

open class EachAIDirectService: EachAIService, DirectService {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directEachAIService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        let requestBuilder = OpenAIDirectRequestBuilder(
            baseURL: "https://flows.eachlabs.ai", // EachAI has different baseURLs depending on which functionality you want to use.
            unprotectedAuthHeader: (key: "X-API-Key", value: unprotectedAPIKey)
        )
        super.init(
            requestBuilder: requestBuilder,
            serviceNetworker: OpenAIDirectServiceNetworker()
        )
    }
}
