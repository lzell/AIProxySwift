//
//  Networker.swift
//
//
//  Created by Lou Zell on 8/24/24.

import Foundation

@NetworkActor
struct BackgroundNetworker {

    // MARK: - Proxied Requests
    static func makeProxiedRequest(_ request: URLRequest) async throws -> Data {
        return try await self.makeRequestAndWaitForData(
            AIProxyURLSession.create(),
            request
        )
    }

    static func makeProxiedRequest(_ request: URLRequest) async throws -> URLSession.AsyncBytes {
        return try await self.makeRequestAndWaitForAsyncBytes(
            AIProxyURLSession.create(),
            request
        )
    }

    // MARK: - Direct Requests
    static func makeDirectRequest(_ request: URLRequest) async throws -> Data {
        return try await self.makeRequestAndWaitForData(
            URLSession(configuration: .ephemeral),
            request
        )
    }

    static func makeDirectRequest(_ request: URLRequest) async throws -> URLSession.AsyncBytes {
        return try await self.makeRequestAndWaitForAsyncBytes(
            URLSession(configuration: .ephemeral),
            request
        )
    }

    // MARK: - Private

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    private static func makeRequestAndWaitForData(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> Data {
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
        return data
    }

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    private static func makeRequestAndWaitForAsyncBytes(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> URLSession.AsyncBytes {
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

        return asyncBytes
    }
}
