//
//  DeepLService.swift
//
//
//  Created by Lou Zell on 12/15/24.
//
import Foundation

@AIProxyActor public protocol DeepLService: Sendable {

    /// Initiates a request to /v2/translate
    ///
    /// - Parameters:
    ///   - body: The translation request. See this reference:
    ///           https://developers.deepl.com/docs/api-reference/translate/openapi-spec-for-text-translation
    /// - Returns: The deserialized response body
    func translateRequest(
        body: DeepLTranslateRequestBody
    ) async throws -> DeepLTranslateResponseBody
}
