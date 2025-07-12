//
//  OpenAIRequestBuilder.swift
//  AIProxy
//
//  Created by Lou Zell on 7/12/25.
//

import Foundation

protocol OpenAIRequestBuilder {
    
    func jsonPOST(
        path: String,
        body: Encodable,
        secondsToWait: UInt,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest
}
