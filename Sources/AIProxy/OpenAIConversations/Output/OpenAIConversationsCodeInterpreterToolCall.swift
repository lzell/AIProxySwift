//
//  OpenAIConversationsCodeInterpreterToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A code interpreter tool call item in a conversation.
nonisolated public struct OpenAIConversationsCodeInterpreterToolCall: Decodable, Sendable {
    /// The type of the item, always "code_interpreter_call".
    public let type: String

    /// The unique ID of the code interpreter call.
    public let id: String

    /// The status of the code interpreter call.
    public let status: String?

    /// The code being interpreted.
    public let code: String?

    /// The outputs from code execution.
    public let outputs: [OpenAIConversationsCodeOutput]?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case code
        case outputs
    }
}

/// An output from code interpreter execution.
nonisolated public struct OpenAIConversationsCodeOutput: Decodable, Sendable {
    /// The type of output.
    public let type: String?

    /// The log output.
    public let logs: String?
}
