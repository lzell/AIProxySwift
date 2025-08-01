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
        additionalHeaders: [String: String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        var additionalHeaders = additionalHeaders
        if let baseURLOverride = baseURLOverride {
            additionalHeaders["aiproxy-base-url"] = baseURLOverride
        }
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

    func multipartPOST(
        path: String,
        body: MultipartFormEncodable,
        secondsToWait: UInt,
        additionalHeaders: [String : String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        var additionalHeaders = additionalHeaders
        if let baseURLOverride = baseURLOverride {
            additionalHeaders["aiproxy-base-url"] = baseURLOverride
        }
        let boundary = UUID().uuidString
        return try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: path,
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: additionalHeaders
        )
    }

    func plainGET(
        path: String,
        secondsToWait: UInt,
        additionalHeaders: [String : String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        var additionalHeaders = additionalHeaders
        if let baseURLOverride = baseURLOverride {
            additionalHeaders["aiproxy-base-url"] = baseURLOverride
        }
        return try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL ?? legacyURL,
            clientID: self.clientID,
            proxyPath: path,
            body: nil,
            verb: .get,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
    }
}
