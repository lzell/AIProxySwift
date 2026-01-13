//
//  OpenAIConversationsFunctionShellCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A function shell call item in a conversation.
nonisolated public struct OpenAIConversationsFunctionShellCall: Decodable, Sendable {
    /// The type of the item, always "function_shell_call".
    public let type: String

    /// The unique ID of the function shell call.
    public let id: String

    /// The ID of the call for tracking.
    public let callId: String?

    /// The status of the function shell call.
    public let status: String?

    /// The name of the function.
    public let name: String?

    /// The arguments as a JSON string.
    public let arguments: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case name
        case arguments
    }
}
