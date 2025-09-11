//
//  BraveDirectService.swift
//  AIProxy
//
//  Created by Lou Zell on 2/7/25.
//

import Foundation

@AIProxyActor final class BraveDirectService: BraveService, DirectService, Sendable {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.braveDirectService` defined in AIProxy.swift
    nonisolated init(unprotectedAPIKey: String) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Makes a web search through Brave. See this reference:
    /// https://api-dashboard.search.brave.com/app/documentation/web-search/get-started
    ///
    /// - Parameters:
    ///   - query: The query to send to Brave
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: The search result. There are many properties on this result, so take some time with
    ///            BraveWebSearchResponseBody to understand how to get the information you want out of it.
    public func webSearchRequest(
        query: String,
        secondsToWait: UInt
    ) async throws -> BraveWebSearchResponseBody {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw AIProxyError.assertion("Could not create an encoded version of query params for brave search")
        }
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.search.brave.com",
            path: "/res/v1/web/search?q=" + encodedQuery,
            body: nil,
            verb: .get,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "X-Subscription-Token": self.unprotectedAPIKey
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}

