//
//  OpenAIShellToolCallOutcome.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// The exit or timeout outcome associated with this shell call.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-shell_tool_call_output-output-outcome
nonisolated public enum OpenAIShellToolCallOutcome: Encodable, Sendable {
    case timeout(OpenAIShellToolCallTimeoutOutcome)
    case exit(OpenAIShellToolCallExitOutcome)
}
