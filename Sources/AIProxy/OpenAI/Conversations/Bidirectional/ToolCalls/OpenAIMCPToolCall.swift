//
//  OpenAIMCPToolCall.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: MCPToolCall, version 2.3.0, line 45923
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-mcp_tool_call
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-mcp_tool_call

/// An invocation of a tool on an MCP server.
nonisolated public struct OpenAIMCPToolCall: Codable, Sendable {
    /// A JSON string of the arguments passed to the tool.
    public let arguments: [String: AIProxyJSONValue]

    /// The unique ID of the tool call.
    public let id: String

    /// The name of the tool that was run.
    public let name: String

    /// The label of the MCP server running the tool.
    public let serverLabel: String

    /// The type of the item. Always `mcp_call`.
    public let type = "mcp_call"

    /// Unique identifier for the MCP tool call approval request.
    ///
    /// Include this value in a subsequent `mcp_approval_response` input to approve or reject the corresponding tool call.
    public let approvalRequestID: String?

    /// The error from the tool call, if any.
    public let error: String?

    /// The output from the tool call.
    public let output: String?

    /// The status of the tool call.
    public let status: OpenAIMCPToolCall.Status?

    /// Creates a new MCP tool call.
    /// - Parameters:
    ///   - arguments: A JSON string of the arguments passed to the tool.
    ///   - id: The unique ID of the tool call.
    ///   - name: The name of the tool that was run.
    ///   - serverLabel: The label of the MCP server running the tool.
    ///   - approvalRequestID: Unique identifier for the MCP tool call approval request.
    ///   - error: The error from the tool call, if any.
    ///   - output: The output from the tool call.
    ///   - status: The status of the tool call.
    public init(
        arguments: [String: AIProxyJSONValue],
        id: String,
        name: String,
        serverLabel: String,
        approvalRequestID: String? = nil,
        error: String? = nil,
        output: String? = nil,
        status: OpenAIMCPToolCall.Status? = nil
    ) {
        self.arguments = arguments
        self.id = id
        self.name = name
        self.serverLabel = serverLabel
        self.approvalRequestID = approvalRequestID
        self.error = error
        self.output = output
        self.status = status
    }

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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arguments, forKey: .arguments)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(serverLabel, forKey: .serverLabel)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(approvalRequestID, forKey: .approvalRequestID)
        try container.encodeIfPresent(error, forKey: .error)
        try container.encodeIfPresent(output, forKey: .output)
        try container.encodeIfPresent(status, forKey: .status)
    }
}

extension OpenAIMCPToolCall {
    /// The status of an MCP tool call.
    public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
        case calling
        case failed
    }
}

