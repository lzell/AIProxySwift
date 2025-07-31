//
//  ServiceMixin.swift
//  AIProxy
//
//  Created by Lou Zell on 4/24/25.
//

import Foundation

protocol ServiceMixin {
    var urlSession: URLSession { get }
}

extension ServiceMixin {
    func makeRequestAndDeserializeResponse<T: Decodable>(_ request: URLRequest) async throws -> T {
        if AIProxyConfiguration.printRequestBodies {
            printRequestBody(request)
        }
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        if AIProxyConfiguration.printResponseBodies {
            printBufferedResponseBody(data)
        }
        return try T.deserialize(from: data)
    }

    func makeRequestAndDeserializeStreamingChunks<T: Decodable>(_ request: URLRequest) async throws -> AsyncThrowingStream<T, Error> {
        if AIProxyConfiguration.printRequestBodies {
            printRequestBody(request)
        }

        let (asyncBytes, _) = try await BackgroundNetworker.makeRequestAndWaitForAsyncBytes(
            self.urlSession,
            request
        )

        let sequence = asyncBytes.lines.compactMap { (line: String) -> T? in
            if AIProxyConfiguration.printResponseBodies {
                printStreamingResponseChunk(line)
            }
            return T.deserialize(fromLine: line)
        }

        // This swift juggling is because I don't want the return types of our API to be
        // something like: AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk>
        //
        // So instead I manually map it to an AsyncStream with a nice signature of AsyncThrowingStream<OpenAIChatCompletionChunk, Error>.
        return AsyncThrowingStream { continuation in
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
    var readableURL: String {
        return self.url?.absoluteString ?? ""
    }

    var readableBody: String {
        guard let body = self.httpBody else {
            return "None"
        }

        return String(data: body, encoding: .utf8) ?? "None"
    }
}

private func printRequestBody(_ request: URLRequest) {
    logIf(.debug)?.debug(
        """
        Making a request to \(request.readableURL)
        with request body:
        \(request.readableBody)
        """
    )
}

private func printBufferedResponseBody(_ data: Data) {
    logIf(.debug)?.debug(
        """
        Received response body:
        \(String(data: data, encoding: .utf8) ?? "")
        """
    )
}

private func printStreamingResponseChunk(_ chunk: String) {
    logIf(.debug)?.debug(
        """
        Received streaming response chunk:
        \(chunk)
        """
    )
}
