//
//  OpenAIMCPToolCallResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: MCPToolCall, version 2.3.0, line 12202

/// An invocation of a tool on an MCP server.
nonisolated public struct OpenAIMCPToolCallResource: Decodable, Sendable {
    /// A JSON string of the arguments passed to the tool.
    public let arguments: String

    /// The unique ID of the tool call.
    public let id: String

    /// The name of the tool that was run.
    public let name: String

    /// The label of the MCP server running the tool.
    public let serverLabel: String

    /// The type of the item. Always `mcp_call`.
    public let type: String

    /// Unique identifier for the MCP tool call approval request.
    ///
    /// Include this value in a subsequent `mcp_approval_response` input to approve or reject
    /// the corresponding tool call.
    public let approvalRequestID: String?

    /// The error from the tool call, if any.
    public let error: String?

    /// The output from the tool call.
    public let output: String?

    /// The status of the tool call.
    ///
    /// One of `in_progress`, `completed`, `incomplete`, `calling`, or `failed`.
    public let status: OpenAIMCPToolCallStatus?

    private enum CodingKeys: String, CodingKey {
        case arguments
        case id
        case name
        case serverLabel = "server_label"
        case type
        case approvalRequestID = "approval_request_id"
        case error
        case output
        case status
    }
}

/// The status of an MCP tool call.
nonisolated public enum OpenAIMCPToolCallStatus: String, Decodable, Sendable {
    case calling
    case completed
    case failed
    case inProgress = "in_progress"
    case incomplete
}
