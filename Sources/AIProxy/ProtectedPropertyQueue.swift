//
//  ProtectedPropertyQueue.swift
//  AIProxy
//
//  Created by Lou Zell on 4/23/25.
//

import Foundation

internal enum ProtectedPropertyQueue {
    static let resolvedAccount = DispatchQueue(
        label: "aiproxy-protected-resolved-account",
        attributes: .concurrent
    )
    static let stableID = DispatchQueue(
        label: "aiproxy-protected-stable-id",
        attributes: .concurrent
    )
    static let useStableID = DispatchQueue(
        label: "aiproxy-protected-use-stable-id",
        attributes: .concurrent
    )
}
