//
//  OpenAIShellToolCallOutcome.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// The exit or timeout outcome associated with this shell call.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-shell_tool_call_output-output-outcome
nonisolated public enum OpenAIShellToolCallOutcome: Encodable, Decodable, Sendable {
    case timeout(OpenAIShellToolCallTimeoutOutcome)
    case exit(OpenAIShellToolCallExitOutcome)
    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "exit":
            self = .exit(try OpenAIShellToolCallExitOutcome(from: decoder))
        case "timeout":
            self = .timeout(try OpenAIShellToolCallTimeoutOutcome(from: decoder))
        default:
            self = .futureProof
            logIf(.error)?.error("Unknown shell call outcome type: \(type)")
        }
    }
}
