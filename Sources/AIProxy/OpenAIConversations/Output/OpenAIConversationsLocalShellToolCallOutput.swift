//
//  OpenAIConversationsLocalShellToolCallOutput.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A local shell tool call output item in a conversation.
nonisolated public struct OpenAIConversationsLocalShellToolCallOutput: Decodable, Sendable {
    /// The type of the item, always "local_shell_call_output".
    public let type: String

    /// The unique ID of the output.
    public let id: String

    /// The ID of the local shell call this output is for.
    public let callId: String?

    /// The status of the output.
    public let status: String?

    /// The output content.
    public let output: OpenAIConversationsLocalShellOutput?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case output
    }
}

/// The output from a local shell call.
nonisolated public struct OpenAIConversationsLocalShellOutput: Decodable, Sendable {
    /// The type of output.
    public let type: String?
}
