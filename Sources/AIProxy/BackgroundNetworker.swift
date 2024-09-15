//
//  Networker.swift
//
//
//  Created by Lou Zell on 8/24/24.

import Foundation

@NetworkActor
struct BackgroundNetworker {
    static func send(
        request: URLRequest
    ) async throws -> (Data, HTTPURLResponse) {
        let session = AIProxyURLSession.create()
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }
        return (data, httpResponse)
    }
}
