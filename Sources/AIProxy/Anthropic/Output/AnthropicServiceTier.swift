//
//  AnthropicServiceTier.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `ServiceTier` object:
/// https://console.anthropic.com/docs/en/api/messages#service_tier
nonisolated public enum AnthropicServiceTier: String, Decodable, Sendable {
    case standard
    case priority
    case batch
    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = Self(rawValue: value) ?? .futureProof
    }
}
