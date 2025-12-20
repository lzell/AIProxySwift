//
//  OpenAIConversationsFunctionToolCallOutput.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A function tool call output item in a conversation.
nonisolated public struct OpenAIConversationsFunctionToolCallOutput: Decodable, Sendable {
    /// The type of the item, always "function_call_output".
    public let type: String

    /// The unique ID of the output.
    public let id: String

    /// The ID of the function call this output is for.
    public let callId: String?

    /// The output of the function call.
    public let output: String?

    /// The status of the output.
    public let status: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case output
        case status
    }
}
