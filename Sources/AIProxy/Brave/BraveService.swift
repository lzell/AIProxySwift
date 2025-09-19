//
//  BraveService.swift
//  AIProxy
//
//  Created by Lou Zell on 2/7/25.
//

import Foundation

@AIProxyActor public protocol BraveService: Sendable {

    /// Makes a web search through Brave. See this reference:
    /// https://api-dashboard.search.brave.com/app/documentation/web-search/get-started
    ///
    /// - Parameters:
    ///   - query: The query to send to Brave
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: The search result. There are many properties on this result, so take some time with
    ///            BraveWebSearchResponseBody to understand how to get the information you want out of it.
    func webSearchRequest(
        query: String,
        secondsToWait: UInt
    ) async throws -> BraveWebSearchResponseBody
}

extension BraveService {
    public func webSearchRequest(query: String) async throws -> BraveWebSearchResponseBody {
        return try await self.webSearchRequest(query: query, secondsToWait: 60)
    }
}
