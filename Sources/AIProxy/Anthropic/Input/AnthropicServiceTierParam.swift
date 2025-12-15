//
//  AnthropicServiceTierParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Service tier options for requests.
nonisolated public enum AnthropicServiceTierParam: String, Encodable, Sendable {
    /// Automatically select between priority and standard capacity.
    case auto

    /// Only use standard capacity.
    case standardOnly = "standard_only"
}
