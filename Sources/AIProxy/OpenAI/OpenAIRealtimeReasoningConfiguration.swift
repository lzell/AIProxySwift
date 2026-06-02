//
//  OpenAIRealtimeReasoningConfiguration.swift
//  AIProxy
//

/// Configuration for OpenAI Realtime Reasoning models such as `gpt-realtime-2`.
nonisolated public struct OpenAIRealtimeReasoningConfiguration: Encodable, Sendable {
    /// Constrains effort on Realtime Reasoning models.
    public let effort: Effort?

    public init(effort: Effort? = nil) {
        self.effort = effort
    }
}

extension OpenAIRealtimeReasoningConfiguration {
    nonisolated public enum Effort: String, Encodable, Sendable {
        case minimal
        case low
        case medium
        case high
        case xhigh
    }
}
