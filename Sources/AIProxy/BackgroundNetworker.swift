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

        @AIProxyActor
        final class Box: Sendable {
            var statusCode: Int = 200
            var accumulatedErrorBody = Data()

            var onResponse: ((URLResponse) -> Void)? = nil
            var onData1: ((Data) -> Void)? = nil
            var onData2: ((Data) -> Void)? = nil
            var onComplete1: ((Error?) -> Void)? = nil
            var onComplete2: ((Error?) -> Void)? = nil

            var isBadStatusCode: Bool {
                return self.statusCode > 299
            }

            func done() {
//                self.onResponse = nil
//                self.onData1 = nil
//                self.onData2 = nil
//                self.onComplete1 = nil
//                self.onComplete2 = nil
            }

            deinit {
                print("the box type is going away!")
            }
        }

        let theBox = Box()
        let task = session.dataTask(with: request)

        if let certPinDelegate = session.delegate as? AIProxyCertificatePinningDelegate {
            certPinDelegate.addLegacyBridgeCallback(for: task) { /*[weak theBox]*/ legacyBridge in
//                guard let theBox = theBox else { return }
                switch legacyBridge {
                case .didReceiveResponse(let response):
                    print("Forwarding response...")
                    theBox.onResponse?(response)
                case .didReceiveData(let data):
                    print("Forwarding data...")
                    theBox.onData1?(data)
                    theBox.onData2?(data)
                case .didComplete(let err):
                    print("Forwarding complete...")
                    theBox.onComplete1?(err)
                    theBox.onComplete2?(err)
                }
            }
        }

        let asyncStream = AsyncStream { /*[weak theBox]*/ continuation in
//            guard let theBox = theBox else { return }
            theBox.onData1 = { data in
                print("GOT DATA!!!")
                Task { @AIProxyActor in
                    continuation.yield(data)
                }
            }

            theBox.onComplete1 = { err in
                print("GOT Compelte!!!")
                Task { @AIProxyActor in
                    print("Use logif here TODO: \(err)")
                    continuation.finish()
                }
            }
        }

        let _: Void = try await withCheckedThrowingContinuation { continuation in
            task.resume()
            theBox.onResponse = { [weak theBox] res in
                guard let theBox = theBox else { return }
                guard let httpResponse = res as? HTTPURLResponse else {
                    theBox.done()
                    continuation.resume(throwing: AIProxyError.assertion("Network response is not an http response"))
                    return
                }
                theBox.statusCode = httpResponse.statusCode
                if !theBox.isBadStatusCode {
                    print("CALLING DONE")
                    theBox.done()
                    continuation.resume()
                }
            }

            theBox.onData2 = { [weak theBox] data in
                print("Getting data in this one.")
                guard let theBox = theBox else { return }
                if theBox.isBadStatusCode {
                    theBox.accumulatedErrorBody += data
                }
            }

            theBox.onComplete2 = { [weak theBox] err in
                print("on complete what the")
                guard let theBox = theBox else { return }
                if theBox.isBadStatusCode {
                    theBox.done()
                    continuation.resume(throwing:
                                            AIProxyError.unsuccessfulRequest(
                                                statusCode: theBox.statusCode,
                                                responseBody: String(data: theBox.accumulatedErrorBody, encoding: .utf8) ?? ""
                                            ))
                }
            }
        }

        return asyncStream
    }

}
