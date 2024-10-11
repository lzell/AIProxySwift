//
//  DeepLService.swift
//
//
//  Created by Lou Zell on 8/3/24.
//

import Foundation

public final class DeepLService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of DeepL service. Note that the initializer is not public.
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
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.createHTTP(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v2/translate",
            body: try JSONEncoder().encode(body),
            verb: .post,
            contentType: "application/json"
        )
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try JSONDecoder().decode(DeepLTranslateResponseBody.self, from: data)
    }
}
