//
//  AIProxyURLSession.swift
//
//
//  Created by Lou Zell on 8/5/24.
//

import Foundation

struct AIProxyURLSession {
    private static let delegate = AIProxyCertificatePinningDelegate()

    /// Creates a URLSession that is configured for communication with aiproxy.pro
    static func create() -> URLSession {
        return URLSession(
            configuration: .default,
            delegate: self.delegate,
            delegateQueue: nil
        )
    }

    init() {
        fatalError("This is a namespace. Please use the factory method AIProxyURLSession.create()")
    }
}
