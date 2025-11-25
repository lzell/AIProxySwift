//
//  URLSessionDataTaskBridge.swift
//  AIProxy
//
//  Created by Lou Zell on 11/24/25.
//

import Foundation

/// A bridge between `URLSession` delegate-style updates and the async/await interface of `BackgroundNetworker`.
/// Used by internal conformers of URLSessionDataTaskDelegate
@AIProxyActor final class URLSessionDataTaskBridge: Sendable {
    var statusCode: Int = 200
    var accumulatedErrorBody = Data()
    var onResponse: [(@AIProxyActor (URLResponse) -> Void)] = []
    var onData: [(@AIProxyActor (Data) -> Void)] = []
    var onComplete: [(@AIProxyActor (Error?) -> Void)] = []

    var isBadStatusCode: Bool {
        return self.statusCode > 299
    }

    deinit {
        logIf(.debug)?.debug("AIProxy: URLSessionDataTaskBridge is being freed")
    }
}
