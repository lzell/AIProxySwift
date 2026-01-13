//
//  OpenAIConversationsMCPApprovalRequest.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An MCP approval request item in a conversation.
nonisolated public struct OpenAIConversationsMCPApprovalRequest: Decodable, Sendable {
    /// The type of the item, always "mcp_approval_request".
    public let type: String

    /// The unique ID of the MCP approval request.
    public let id: String

    /// The status of the MCP approval request.
    public let status: String?

    /// The server label.
    public let serverLabel: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case status
        case serverLabel = "server_label"
    }
}
