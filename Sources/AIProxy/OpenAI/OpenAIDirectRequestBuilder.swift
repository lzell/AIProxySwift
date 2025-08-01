//
//  OpenAIDirectRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

internal struct OpenAIDirectRequestBuilder: OpenAIRequestBuilder {
    let baseURL: String
    let unprotectedAuthHeader: (key: String, value: String)

    init(baseURL: String, unprotectedAuthHeader: (key: String, value: String)) {
        self.baseURL = baseURL
        self.unprotectedAuthHeader = unprotectedAuthHeader
    }

    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        return try AIProxyURLRequest.createDirect(
            baseURL: baseURLOverride ?? self.baseURL,
            path: path,
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: self.mergedHeaders(additionalHeaders: additionalHeaders)
        )
    }

    func multipartPOST(
        path: String,
        body: MultipartFormEncodable,
        secondsToWait: UInt,
        additionalHeaders: [String : String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        let boundary = UUID().uuidString
        return try AIProxyURLRequest.createDirect(
            baseURL: baseURLOverride ?? self.baseURL,
            path: path,
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: self.mergedHeaders(additionalHeaders: additionalHeaders)
        )
    }

    func plainGET(
        path: String,
        secondsToWait: UInt,
        additionalHeaders: [String : String],
        baseURLOverride: String?
    ) async throws -> URLRequest {
        return try AIProxyURLRequest.createDirect(
            baseURL: baseURLOverride ?? self.baseURL,
            path: path,
            body: nil,
            verb: .get,
            secondsToWait: secondsToWait,
            additionalHeaders: self.mergedHeaders(additionalHeaders: additionalHeaders)
        )
    }

    private func mergedHeaders(additionalHeaders: [String: String]) -> [String: String] {
        var mergedHeaders = additionalHeaders

        if mergedHeaders[self.unprotectedAuthHeader.key] == nil {
            mergedHeaders[self.unprotectedAuthHeader.key] = self.unprotectedAuthHeader.value
        }
        return mergedHeaders
    }
}
