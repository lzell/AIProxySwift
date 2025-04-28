//
//  AIProxyURLSession.swift
//
//
//  Created by Lou Zell on 8/5/24.
//

import Foundation

public enum AIProxyURLSession {
    public static var delegate = AIProxyCertificatePinningDelegate()

    /// Creates a URLSession that is configured for communication with aiproxy.pro
    static func create() -> URLSession {
        return URLSession(
            configuration: .ephemeral,
            delegate: self.delegate,
            delegateQueue: nil
        )
    }

}
