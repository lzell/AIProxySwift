//
//  OpenAIConversationsComputerToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A computer use tool call item in a conversation.
nonisolated public struct OpenAIConversationsComputerToolCall: Decodable, Sendable {
    /// The type of the item, always "computer_call".
    public let type: String

    /// The unique ID of the computer call.
    public let id: String

    /// The ID of the computer call for tracking.
    public let callId: String?

    /// The status of the computer call.
    public let status: String?

    /// The action being performed.
    public let action: OpenAIConversationsComputerAction?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case action
    }
}

/// An action for computer use.
nonisolated public struct OpenAIConversationsComputerAction: Decodable, Sendable {
    /// The type of action.
    public let type: String?
}
