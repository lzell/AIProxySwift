//
//  ProxiedService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

protocol ProxiedService {}
extension ProxiedService {
    var urlSession: URLSession {
        return AIProxyUtils.proxiedURLSession()
    }

    func makeRequestAndDeserializeResponse<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try T.deserialize(from: data)
    }

    func makeRequestAndDeserializeStreamingChunks<T: Decodable>(_ request: URLRequest) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, T> {
        let (asyncBytes, _) = try await BackgroundNetworker.makeRequestAndWaitForAsyncBytes(
            self.urlSession,
            request
        )
        return asyncBytes.lines.compactMap { T.deserialize(fromLine: $0) }
    }
}
