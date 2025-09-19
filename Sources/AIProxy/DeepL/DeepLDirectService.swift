//
//  DeepLDirectService.swift
//
//
//  Created by Lou Zell on 12/15/24.
//

import Foundation

@AIProxyActor final class DeepLDirectService: DeepLService, DirectService, Sendable {
    private let unprotectedAPIKey: String
    private let accountType: DeepLAccountType

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directDeepLService` defined in AIProxy.swift
    nonisolated init(unprotectedAPIKey: String, accountType: DeepLAccountType) {
        self.unprotectedAPIKey = unprotectedAPIKey
        self.accountType = accountType
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.accountType == .free ? "https://api-free.deepl.com" : "https://api.deepl.com",
            path: "/v2/translate",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "DeepL-Auth-Key \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
