//
//  OpenAIConversationsFunctionToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A function tool call item in a conversation.
nonisolated public struct OpenAIConversationsFunctionToolCall: Decodable, Sendable {
    /// The type of the item, always "function_call".
    public let type: String

    /// The unique ID of the function call.
    public let id: String

    /// The ID of the function call for tracking.
    public let callId: String?

    /// The name of the function being called.
    public let name: String?

    /// The arguments passed to the function as a JSON string.
    public let arguments: String?

    /// The status of the function call.
    public let status: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case name
        case arguments
        case status
    }
}
