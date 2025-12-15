//
//  AnthropicStopReason.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// Represents Anthropic's `StopReason` object:
/// https://console.anthropic.com/docs/en/api/messages#stop_reason
nonisolated public enum AnthropicStopReason: String, Decodable, Sendable {
    /// The model reached a natural stopping point.
    case endTurn = "end_turn"

    /// We exceeded the requested `max_tokens` or the model's maximum.
    case maxTokens = "max_tokens"

    /// One of your provided custom `stop_sequences` was generated.
    case stopSequence = "stop_sequence"

    /// The model invoked one or more tools.
    case toolUse = "tool_use"

    /// We paused a long-running turn. You may provide the response back as-is in a subsequent
    /// request to let the model continue.
    case pauseTurn = "pause_turn"

    /// Streaming classifiers intervened to handle potential policy violations.
    case refusal

    /// Unknown stop reason for future compatibility.
    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = Self(rawValue: value) ?? .futureProof
    }
}
