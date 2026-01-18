//
//  AnthropicRequestMetadata.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Request metadata.
nonisolated public struct AnthropicRequestMetadata: Encodable, Sendable {
    /// An external identifier for the user who is associated with the request.
    ///
    /// This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id
    /// to help detect abuse. Do not include any identifying information such as name, email
    /// address, or phone number.
    public let userId: String?

    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }

    public init(userId: String? = nil) {
        self.userId = userId
    }
}
