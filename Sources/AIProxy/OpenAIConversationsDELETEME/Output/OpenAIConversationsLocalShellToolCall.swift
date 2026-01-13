//
//  OpenAIConversationsLocalShellToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A local shell tool call item in a conversation.
nonisolated public struct OpenAIConversationsLocalShellToolCall: Decodable, Sendable {
    /// The type of the item, always "local_shell_call".
    public let type: String

    /// The unique ID of the local shell call.
    public let id: String

    /// The ID of the call for tracking.
    public let callId: String?

    /// The status of the local shell call.
    public let status: String?

    /// The action being performed.
    public let action: OpenAIConversationsLocalShellAction?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case action
    }
}

/// An action for local shell.
nonisolated public struct OpenAIConversationsLocalShellAction: Decodable, Sendable {
    /// The type of action.
    public let type: String?

    /// The command to execute.
    public let command: [String]?
}
