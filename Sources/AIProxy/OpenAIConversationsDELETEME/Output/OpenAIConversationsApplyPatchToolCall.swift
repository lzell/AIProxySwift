//
//  OpenAIConversationsApplyPatchToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An apply patch tool call item in a conversation.
nonisolated public struct OpenAIConversationsApplyPatchToolCall: Decodable, Sendable {
    /// The type of the item, always "apply_patch_call".
    public let type: String

    /// The unique ID of the apply patch call.
    public let id: String

    /// The ID of the call for tracking.
    public let callId: String?

    /// The status of the apply patch call.
    public let status: String?

    /// The patch content.
    public let patch: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case patch
    }
}
