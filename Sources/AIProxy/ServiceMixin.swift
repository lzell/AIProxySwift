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

    func makeRequestAndDeserializeStreamingChunks<T: Decodable>(_ request: URLRequest) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, T> {
        if AIProxy.printRequestBodies {
            printRequestBody(request)
        }
        let (asyncBytes, _) = try await BackgroundNetworker.makeRequestAndWaitForAsyncBytes(
            self.urlSession,
            request
        )
        return asyncBytes.lines.compactMap {
            if AIProxy.printResponseBodies {
                printStreamingResponseChunk($0)
            }
            return T.deserialize(fromLine: $0)
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
