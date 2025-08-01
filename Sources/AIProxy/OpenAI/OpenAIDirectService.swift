//
//  OpenAIDirectService.swift
//
//
//  Created by Lou Zell on 12/14/24.
//

open class OpenAIDirectService: OpenAIService, DirectService {
    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directOpenAIService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String,
        requestFormat: OpenAIRequestFormat = .standard,
        baseURL: String? = nil
    ) {
        let baseURL = baseURL ?? "https://api.openai.com"
        let requestBuilder = OpenAIDirectRequestBuilder(
            baseURL: baseURL,
            unprotectedAuthHeader: (key: "Authorization", value: "Bearer \(unprotectedAPIKey)")
        )
        super.init(
            requestFormat: requestFormat,
            requestBuilder: requestBuilder,
            serviceNetworker: OpenAIDirectServiceNetworker()
        )
    }
}
