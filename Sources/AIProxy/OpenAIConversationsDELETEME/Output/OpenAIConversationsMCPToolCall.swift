//
//  OpenAIConversationsMCPToolCall.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An MCP tool call item in a conversation.
nonisolated public struct OpenAIConversationsMCPToolCall: Decodable, Sendable {
    /// The type of the item, always "mcp_call".
    public let type: String

    /// The unique ID of the MCP tool call.
    public let id: String

    /// The ID of the call for tracking.
    public let callId: String?

    /// The status of the MCP tool call.
    public let status: String?

    /// The server label.
    public let serverLabel: String?

    /// The name of the tool.
    public let name: String?

    /// The arguments as a JSON string.
    public let arguments: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case callId = "call_id"
        case status
        case serverLabel = "server_label"
        case name
        case arguments
    }
}
