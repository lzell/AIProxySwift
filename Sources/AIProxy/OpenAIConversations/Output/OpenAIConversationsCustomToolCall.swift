//
//  OpenAIConversationsCustomToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A custom tool call item in a conversation.
nonisolated public struct OpenAIConversationsCustomToolCall: Decodable, Sendable {
    /// The type of the item.
    public let type: String

    /// The unique ID of the custom tool call.
    public let id: String

    /// The ID of the call for tracking.
    public let callId: String?

    /// The status of the custom tool call.
    public let status: String?

    /// The name of the tool.
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
