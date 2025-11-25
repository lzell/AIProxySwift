//
//  DirectURLSessionDataDelegate.swift
//  AIProxy
//
//  Created by Lou Zell on 11/24/25.
//

import Foundation

nonisolated final class DirectURLSessionDataDelegate: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    /// Why is this needed?
    /// For some streaming use cases, we don't want to always consume textual lines through the modern `asyncBytes.lines` helper.
    /// Some use cases require vending data as it arrives off the wire, such as streaming audio.
    /// Unfortunately, modern async/await URLSession APIs don't provide this functionality out of the box.
    /// This closure acts as a bridge to the legacy delegate-based URLSession partial data vendor.
    nonisolated(unsafe) private var _bridges: [URLSessionDataTask: URLSessionDataTaskBridge] = [:]
    var bridges: [URLSessionDataTask: URLSessionDataTaskBridge] {
        get {
            ProtectedPropertyQueue.urlSessionBridges.sync { self._bridges }
        }
    }

    func addBridge(for dataTask: URLSessionDataTask, box: URLSessionDataTaskBridge) {
        ProtectedPropertyQueue.urlSessionBridges.async(flags: .barrier) {
            self._bridges[dataTask] = box
        }
    }

    func removeBridge(for dataTask: URLSessionDataTask) {
        ProtectedPropertyQueue.urlSessionBridges.async(flags: .barrier) {
            self._bridges.removeValue(forKey: dataTask)
        }
    }

    // MARK: - URLSessionTaskDelegate
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        guard let dataTask = task as? URLSessionDataTask else {
            return
        }
        Task { @AIProxyActor in
            for completeCallback in self.bridges[dataTask]?.onComplete ?? [] {
                completeCallback(error)
            }
            self.removeBridge(for: dataTask)
        }
    }

    // MARK: - URLSessionDataDelegate conformance
    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @Sendable @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        Task { @AIProxyActor in
            for responseCallback in self.bridges[dataTask]?.onResponse ?? [] {
                responseCallback(response)
            }
        }
        completionHandler(.allow)
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {
        Task { @AIProxyActor in
            for dataCallback in self.bridges[dataTask]?.onData ?? [] {
                dataCallback(data)
            }
        }
    }

}
