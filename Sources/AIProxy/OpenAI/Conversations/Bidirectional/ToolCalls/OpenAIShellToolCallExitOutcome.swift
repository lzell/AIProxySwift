//
//  OpenAIShellToolCallExitOutcome.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
// 65471     FunctionShellCallOutputExitOutcome

/// Indicates that the shell commands finished and returned an exit code.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-shell_tool_call_output-output-outcome-shell_call_exit_outcome
nonisolated public struct OpenAIShellToolCallExitOutcome: Codable, Sendable {
    /// The exit code returned by the shell process.
    public let exitCode: Int
    
    /// The outcome type. Always `exit`.
    public let type = "exit"
    
    /// Creates a new shell call exit outcome parameter.
    /// - Parameters:
    ///   - exitCode: The exit code returned by the shell process.
    public init(exitCode: Int) {
        self.exitCode = exitCode
    }
    
    private enum CodingKeys: String, CodingKey {
        case exitCode = "exit_code"
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exitCode, forKey: .exitCode)
        try container.encode(type, forKey: .type)
    }
}
