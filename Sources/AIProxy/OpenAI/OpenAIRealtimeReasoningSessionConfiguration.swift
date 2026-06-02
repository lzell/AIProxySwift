//
//  OpenAIRealtimeReasoningSessionConfiguration.swift
//  AIProxy
//

/// Session configuration for Realtime Reasoning models.
///
/// The Realtime API still expects one `session.update.session` object. This type composes
/// the shared Realtime session configuration with Reasoning-only fields and flattens them
/// into that single wire object when encoded.
nonisolated public struct OpenAIRealtimeReasoningSessionConfiguration: Encodable, Sendable {
    public let session: OpenAIRealtimeSessionConfiguration
    public let reasoning: OpenAIRealtimeReasoningConfiguration?
    public let parallelToolCalls: Bool?

    public init(
        session: OpenAIRealtimeSessionConfiguration,
        reasoning: OpenAIRealtimeReasoningConfiguration? = nil,
        parallelToolCalls: Bool? = nil
    ) {
        self.session = session
        self.reasoning = reasoning
        self.parallelToolCalls = parallelToolCalls
    }
}
