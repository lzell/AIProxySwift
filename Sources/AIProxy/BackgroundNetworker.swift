//
//  Networker.swift
//
//
//  Created by Lou Zell on 8/24/24.

import Foundation

struct BackgroundNetworker {

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    @AIProxyActor static func makeRequestAndWaitForData(
        _ session: URLSession,
        _ request: URLRequest,
        _ progressCallback: (@Sendable (Double) -> Void)? = nil
    ) async throws -> (Data, HTTPURLResponse) {
        if let progressCallback {
            (session.delegate as? AIProxyCertificatePinningDelegate)?.progressCallback = progressCallback
        }
        let (data, res) = try await session.data(
            for: request,
            delegate: session.delegate as? URLSessionTaskDelegate
        )
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }
        if httpResponse.statusCode > 299 {
            logIf(.error)?.error("Receieved a non-200 status code: \(httpResponse.statusCode)")
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
        return (data, httpResponse)
    }

    /// Throws AIProxyError.unsuccessfulRequest if the returned status code is non-200
    @AIProxyActor static func makeRequestAndWaitForAsyncBytes(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> (URLSession.AsyncBytes, HTTPURLResponse) {
        let (asyncBytes, res) = try await session.bytes(
            for: request,
            delegate: session.delegate as? URLSessionTaskDelegate
        )

        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            var responseBody = ""
            for try await line in asyncBytes.lines {
                responseBody += line
            }
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: responseBody
            )
        }
        return (asyncBytes, httpResponse)
    }

    // This has a major limitation. All requests overwrite the `legacyBridge` callback.
    // It would be better to add listeners to a set, and remove them when listening is complete.
    @AIProxyActor static func makeRequestAndVendChunks(
        _ session: URLSession,
        _ request: URLRequest
    ) async throws -> AsyncStream<Data> {

        final class Box: Sendable {
            @AIProxyActor var value: Bool
            init(_ value: Bool) { self.value = value }
        }

        let accumulateErrorBodyBox = Box(false)
        // Marry this:
        return AsyncStream { continuation in
            let task = session.dataTask(with: request)
            (session.delegate as? AIProxyCertificatePinningDelegate)?.legacyBridgeCallback = { legacyBridge in
                Task { @AIProxyActor in
                    switch legacyBridge {
                    case .didReceiveResponse(let dataTask, let response):
                        if dataTask == task {
                            guard let httpResponse = response as? HTTPURLResponse else {
                                logIf(.error)?.error("Network response is not an http response")
                                return
                            }
                            if (httpResponse.statusCode > 299) {
                                accumulateErrorBodyBox.value = true
                            }
                        }
                    case .didReceiveData(let dataTask, let data):
                        if accumulateErrorBodyBox.value {

                        } else {
                            continuation.yield(data)
                        }
                    case .didComplete(let task):
                        break
                    }
                }
            }
            task.resume()
        }

        // With this:
//        let (asyncBytes, res) = try await session.bytes(
//            for: request,
//            delegate: session.delegate as? URLSessionTaskDelegate
//        )
//
//        guard let httpResponse = res as? HTTPURLResponse else {
//            throw AIProxyError.assertion("Network response is not an http response")
//        }
//
//        if (httpResponse.statusCode > 299) {
//            var responseBody = ""
//            for try await line in asyncBytes.lines {
//                responseBody += line
//            }
//            throw AIProxyError.unsuccessfulRequest(
//                statusCode: httpResponse.statusCode,
//                responseBody: responseBody
//            )
//        }
//        return (asyncBytes, httpResponse)
    }

}
