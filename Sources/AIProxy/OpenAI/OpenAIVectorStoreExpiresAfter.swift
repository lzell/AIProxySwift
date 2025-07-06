//
//  OpenAIVectorStoreExpiresAfter.swift
//  AIProxy
//
//  Created by Lou Zell on 7/6/25.
//

/// The expiration policy for a vector store.
public struct OpenAIVectorStoreExpiresAfter: Codable {
    /// Anchor timestamp after which the expiration policy applies
    public let anchor: Anchor

    /// The number of days after the anchor time that the vector store will expire.
    public let days: Int

    public init(anchor: Anchor, days: Int) {
        self.anchor = anchor
        self.days = days
    }
}

extension OpenAIVectorStoreExpiresAfter {
    public enum Anchor: String, Codable {
        case lastActiveAt = "last_active_at"
    }
}
