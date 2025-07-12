//
//  OpenAIProxiedRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

private let legacyURL = "https://api.aiproxy.pro"

internal struct OpenAIProxiedRequestBuilder: OpenAIRequestBuilder {
    let partialKey: String
    let serviceURL: String?
    let clientID: String?

    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest {
        return try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: path,
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: additionalHeaders
        )
    }
}
