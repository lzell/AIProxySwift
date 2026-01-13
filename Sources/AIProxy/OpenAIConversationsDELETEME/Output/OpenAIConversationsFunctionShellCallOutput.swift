//
//  OpenAIConversationsFunctionShellCallOutput.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A function shell call output item in a conversation.
nonisolated public struct OpenAIConversationsFunctionShellCallOutput: Decodable, Sendable {
    /// The type of the item, always "function_shell_call_output".
    public let type: String

    /// The unique ID of the output.
    public let id: String

    /// The ID of the function shell call this output is for.
    public let callId: String?

    /// The status of the output.
    public let status: String?

    /// The output of the function shell call.
    public let output: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case output
    }
}
