//
//  OpenAIConversationsMCPApprovalResponse.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An MCP approval response item in a conversation.
nonisolated public struct OpenAIConversationsMCPApprovalResponse: Decodable, Sendable {
    /// The type of the item, always "mcp_approval_response".
    public let type: String

    /// The unique ID of the MCP approval response.
    public let id: String

    /// The ID of the approval request this responds to.
    public let approvalRequestId: String?

    /// Whether the request was approved.
    public let approved: Bool?

    /// The status of the MCP approval response.
    public let status: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case approvalRequestId = "approval_request_id"
        case approved
        case status
    }
}
