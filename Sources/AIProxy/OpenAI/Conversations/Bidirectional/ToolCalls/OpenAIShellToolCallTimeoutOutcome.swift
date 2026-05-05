//
//  OpenAIShellToolCallTimeoutOutcome.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// 65457     FunctionShellCallOutputTimeoutOutcome

/// Indicates that the shell call exceeded its configured time limit.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-shell_tool_call_output-output-outcome-shell_call_timeout_outcome
nonisolated public struct OpenAIShellToolCallTimeoutOutcome: Codable, Sendable {
    /// The outcome type. Always `timeout`.
    public let type = "timeout"
    
    /// Creates a new shell call timeout outcome parameter.
    public init() {}
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
    }
}
