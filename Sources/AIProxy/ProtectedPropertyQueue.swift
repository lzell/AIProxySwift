//
//  ProtectedPropertyQueue.swift
//  AIProxy
//
//  Created by Lou Zell on 4/23/25.
//

import Foundation

nonisolated enum ProtectedPropertyQueue {

    static let configuration = DispatchQueue(
        label: "aiproxy-protected-configuration",
        attributes: .concurrent
    )

    static let callerDesiredLogLevel = DispatchQueue(
        label: "aiproxy-protected-caller-desired-log-level",
        attributes: .concurrent
    )

    static let progressCallback = DispatchQueue(
        label: "aiproxy-protected-progress-callback",
        attributes: .concurrent
    )

    static let urlSessionBridges = DispatchQueue(
        label: "aiproxy-protected-url-session-bridges",
        attributes: .concurrent
    )
}
