//
//  Networker.swift
//
//
//  Created by Lou Zell on 8/24/24.

import Foundation

@NetworkActor
struct BackgroundNetworker {

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    static func makeRequestAndWaitForData(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }
        if httpResponse.statusCode > 299 {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
        return (data, httpResponse)
    }

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    static func makeRequestAndWaitForAsyncBytes(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> (URLSession.AsyncBytes, HTTPURLResponse) {
        let (asyncBytes, res) = try await session.bytes(for: request)

        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            let responseBody = try await asyncBytes.lines.reduce(into: "") { $0 += $1 }
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: responseBody
            )
        }

        return (asyncBytes, httpResponse)
    }
}
