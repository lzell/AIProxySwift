//
//  OpenAIConversationsOrderParam.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Sort order for listing items.
nonisolated public enum OpenAIConversationsOrderParam: String, Sendable {
    /// Ascending order (oldest first).
    case asc

    /// Descending order (newest first).
    case desc
}
