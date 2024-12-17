//
//  DeepLProxiedService.swift
//
//
//  Created by Lou Zell on 8/3/24.
//

import Foundation

open class DeepLProxiedService: DeepLService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.deepLService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a request to /v2/translate
    ///
    /// - Parameters:
    ///   - body: The translation request. See this reference:
    ///           https://developers.deepl.com/docs/api-reference/translate/openapi-spec-for-text-translation
    /// - Returns: The deserialized response body
    public func translateRequest(
        body: DeepLTranslateRequestBody
    ) async throws -> DeepLTranslateResponseBody {
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v2/translate",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
