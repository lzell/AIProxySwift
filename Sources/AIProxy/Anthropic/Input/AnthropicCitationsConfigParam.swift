//
//  AnthropicCitationsConfigParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/9/25.
//

/// Represents Anthropic's `CitationsConfigParam` object:
/// https://console.anthropic.com/docs/en/api/messages#citations_config_param
nonisolated public struct AnthropicCitationsConfigParam: Encodable, Sendable {
    /// Whether citations are enabled.
    public let enabled: Bool?

    public init(enabled: Bool? = nil) {
        self.enabled = enabled
    }
}
