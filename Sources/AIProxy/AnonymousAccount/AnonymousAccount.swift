//
//  AnonymousAccount.swift
//  AIProxy
//
//  Created by Lou Zell on 2/2/25.
//

/// A best-effort anonymous ID that is stable across multiple devices of an iCloud account
struct AnonymousAccount: Codable, Equatable {
    /// UUID of the anonymous account
    let uuid: String

    /// Unix time that the UUID was created
    let timestamp: Double
}
