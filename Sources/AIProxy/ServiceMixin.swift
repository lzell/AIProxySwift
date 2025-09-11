//
//  ServiceMixin.swift
//  AIProxy
//
//  Created by Lou Zell on 4/24/25.
//

import Foundation

@AIProxyActor protocol ServiceMixin: Sendable {
    var urlSession: URLSession { get }
}

extension ServiceMixin {
    @AIProxyActor func makeRequestAndDeserializeResponse<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        if AIProxy.printRequestBodies {
            printRequestBody(request)
        }
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        if AIProxy.printResponseBodies {
            printBufferedResponseBody(data)
        }
        return try T.deserialize(from: data)
    }

    @AIProxyActor func makeRequestAndDeserializeStreamingChunks<T: Decodable & Sendable>(_ request: URLRequest) async throws -> AsyncThrowingStream<T, Error> {
        if AIProxy.printRequestBodies {
            printRequestBody(request)
        }

        let (asyncBytes, _) = try await BackgroundNetworker.makeRequestAndWaitForAsyncBytes(
            self.urlSession,
            request
        )

        let sequence = asyncBytes.lines.compactMap { @AIProxyActor [shouldPrint = AIProxy.printResponseBodies] (line: String) -> T? in
            if shouldPrint {
                printStreamingResponseChunk(line)
            }
            return T.deserialize(fromLine: line)
        }

        // This swift juggling is because I don't want the return types of our API to be
        // something like: AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk>
        //
        // So instead I manually map it to an AsyncStream with a nice signature of AsyncThrowingStream<OpenAIChatCompletionChunk, Error>.
        return AsyncThrowingStream { @AIProxyActor continuation in
            let task = Task {
                do {
                    for try await item in sequence {
                        if Task.isCancelled {
                            break
                        }
                        continuation.yield(item)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

private extension URLRequest {
    nonisolated var readableURL: String {
        return self.url?.absoluteString ?? ""
    }

    nonisolated var readableBody: String {
        guard let body = self.httpBody else {
            return "None"
        }

        return String(data: body, encoding: .utf8) ?? "None"
    }
}

nonisolated private func printRequestBody(_ request: URLRequest) {
    logIf(.debug)?.debug(
        """
        Making a request to \(request.readableURL)
        with request body:
        \(request.readableBody)
        """
    )
}

nonisolated private func printBufferedResponseBody(_ data: Data) {
    logIf(.debug)?.debug(
        """
        Received response body:
        \(String(data: data, encoding: .utf8) ?? "")
        """
    )
}

nonisolated private func printStreamingResponseChunk(_ chunk: String) {
    logIf(.debug)?.debug(
        """
        Received streaming response chunk:
        \(chunk)
        """
    )
}
