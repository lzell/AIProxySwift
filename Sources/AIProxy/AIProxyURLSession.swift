//
//  AIProxyURLSession.swift
//
//
//  Created by Lou Zell on 8/5/24.
//

import Foundation

nonisolated public enum AIProxyURLSession {
    public static let delegate = AIProxyCertificatePinningDelegate()

    /// Creates a URLSession that is configured for communication with aiproxy.com
    static func create() -> URLSession {
        return URLSession(
            configuration: .ephemeral,
            delegate: self.delegate,
            delegateQueue: nil
        )
    }
}
