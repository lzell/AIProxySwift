//
//  OpenAIConversationsApplyPatchToolCallOutput.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An apply patch tool call output item in a conversation.
nonisolated public struct OpenAIConversationsApplyPatchToolCallOutput: Decodable, Sendable {
    /// The type of the item, always "apply_patch_call_output".
    public let type: String

    /// The unique ID of the output.
    public let id: String

    /// The ID of the apply patch call this output is for.
    public let callId: String?

    /// The status of the output.
    public let status: String?

    /// The output of the apply patch call.
    public let output: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case output
    }
}
