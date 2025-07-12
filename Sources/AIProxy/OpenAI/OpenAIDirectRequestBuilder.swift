//
//  OpenAIDirectRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

internal struct OpenAIDirectRequestBuilder: OpenAIRequestBuilder {
    let baseURL: String
    let unprotectedAPIKey: String

    init(baseURL: String, unprotectedAPIKey: String) {
        self.baseURL = baseURL
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    func jsonPOST(path: String, body: Encodable, secondsToWait: UInt, additionalHeaders: [String: String]) async throws -> URLRequest {
        var mergedHeaders = additionalHeaders
        mergedHeaders["Authorization"] = "Bearer \(self.unprotectedAPIKey)"
        return try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: path,
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: mergedHeaders
        )
    }
}
