//
//  OpenAIRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

internal protocol OpenAIRequestBuilder {

    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest

    func multipartPOST(
        path: String,
        body: MultipartFormEncodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest

    func plainGET(
        path: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest
}
