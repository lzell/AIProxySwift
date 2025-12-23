//
//  OpenAIMCPApprovalRequestResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: MCPApprovalRequest, version 2.3.0, line 11916

/// A request for human approval of a tool invocation.
nonisolated public struct OpenAIMCPApprovalRequestResource: Decodable, Sendable {
    /// A JSON string of arguments for the tool.
    public let arguments: String

    /// The unique ID of the approval request.
    public let id: String

    /// The name of the tool to run.
    public let name: String

    /// The label of the MCP server making the request.
    public let serverLabel: String

    /// The type of the item. Always `mcp_approval_request`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case arguments
        case id
        case name
        case serverLabel = "server_label"
        case type
    }
}
