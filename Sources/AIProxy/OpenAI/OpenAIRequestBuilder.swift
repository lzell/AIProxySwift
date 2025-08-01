//
//  OpenAIRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

// TODO: Rename this to AIProxyRequestBuilder.
//       It's generic enough for other services
internal protocol OpenAIRequestBuilder {

    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String],
        baseURLOverride: String?
    ) async throws -> URLRequest

    func multipartPOST(
        path: String,
        body: MultipartFormEncodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String],
        baseURLOverride: String?
    ) async throws -> URLRequest

    func plainGET(
        path: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String],
        baseURLOverride: String?
    ) async throws -> URLRequest
}

extension OpenAIRequestBuilder {
    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest {
        try await jsonPOST(
            path: path,
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders,
            baseURLOverride: nil
        )
    }

    func multipartPOST(
        path: String,
        body: MultipartFormEncodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest {
        try await multipartPOST(
            path: path,
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders,
            baseURLOverride: nil
        )
    }

    func plainGET(
        path: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest {
        try await plainGET(
            path: path,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders,
            baseURLOverride: nil
        )
    }
}
