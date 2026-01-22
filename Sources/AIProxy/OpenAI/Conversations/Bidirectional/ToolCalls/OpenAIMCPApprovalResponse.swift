//
//  OpenAIMCPApprovalResponse.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: MCPApprovalResponse, version 2.3.0, line 45672
// OpenAPI spec: MCPApprovalResponseResource, version 2.3.0, line 45710
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-mcp_approval_response
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-mcp_approval_response

/// A response to an MCP approval request.
nonisolated public struct OpenAIMCPApprovalResponse: Codable, Sendable {
    /// The ID of the approval request being answered.
    public let approvalRequestID: String

    /// Whether the request was approved.
    public let approve: Bool

    /// The unique ID of the approval response.
    public let id: String

    /// The type of the item. Always `mcp_approval_response`.
    public let type = "mcp_approval_response"

    /// Optional reason for the decision.
    public let reason: String?

    /// Creates a new MCP approval response.
    /// - Parameters:
    ///   - approvalRequestID: The ID of the approval request being answered.
    ///   - approve: Whether the request was approved.
    ///   - id: The unique ID of the approval response.
    ///   - reason: Optional reason for the decision.
    public init(
        approvalRequestID: String,
        approve: Bool,
        id: String,
        reason: String? = nil
    ) {
        self.approvalRequestID = approvalRequestID
        self.approve = approve
        self.id = id
        self.reason = reason
    }

    private enum CodingKeys: String, CodingKey {
        case approvalRequestID = "approval_request_id"
        case approve
        case type
        case id
        case reason
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(approvalRequestID, forKey: .approvalRequestID)
        try container.encode(approve, forKey: .approve)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(reason, forKey: .reason)
    }
}
