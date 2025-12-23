//
//  OpenAIMCPApprovalResponseResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: MCPApprovalResponseResource, version 2.3.0, line 11989

/// A response to an MCP approval request.
nonisolated public struct OpenAIMCPApprovalResponseResource: Decodable, Sendable {
    /// The ID of the approval request being answered.
    public let approvalRequestID: String

    /// Whether the request was approved.
    public let approve: Bool

    /// The unique ID of the approval response.
    public let id: String

    /// The type of the item. Always `mcp_approval_response`.
    public let type: String

    /// Optional reason for the decision.
    public let reason: String?

    private enum CodingKeys: String, CodingKey {
        case approvalRequestID = "approval_request_id"
        case approve
        case id
        case type
        case reason
    }
}
