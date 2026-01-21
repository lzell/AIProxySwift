//
//  OpenAIShellToolCallOutcome.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// The exit or timeout outcome associated with this shell call.
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-shell_tool_call_output-output-outcome
nonisolated public enum OpenAIShellToolCallOutcome: Codable, Sendable {
    case timeout(OpenAIShellToolCallTimeoutOutcome)
    case exit(OpenAIShellToolCallExitOutcome)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

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

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .timeout(let outcome):
            try outcome.encode(to: encoder)
        case .exit(let outcome):
            try outcome.encode(to: encoder)
        case .futureProof:
            break
        }
    }
}
