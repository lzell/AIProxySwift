//
//  OpenAIItemOrder.swift
//  AIProxy
//
//  Created by Lou Zell on 1/14/26.
//

/// Sort order for listing items.
nonisolated public enum OpenAIItemOrder: String, Sendable {
    /// Ascending order (oldest first).
    case asc

    /// Descending order (newest first).
    case desc
}
