//
//  OpenAIConversationsCustomToolCallOutput.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A custom tool call output item in a conversation.
nonisolated public struct OpenAIConversationsCustomToolCallOutput: Decodable, Sendable {
    /// The type of the item.
    public let type: String

    /// The unique ID of the output.
    public let id: String

    /// The ID of the custom tool call this output is for.
    public let callId: String?

    /// The status of the output.
    public let status: String?

    /// The output of the custom tool call.
    public let output: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case output
    }
}
