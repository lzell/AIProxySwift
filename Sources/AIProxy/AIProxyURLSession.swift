//
//  AIProxyURLSession.swift
//
//
//  Created by Lou Zell on 8/5/24.
//

import Foundation

nonisolated public enum AIProxyURLSession {
    public static let delegate = AIProxyCertificatePinningDelegate()

    /// A URLSession that is configured for communication with aiproxy.com
    static let urlSession = URLSession(
        configuration: .ephemeral,
        delegate: delegate,
        delegateQueue: nil
    )
}
