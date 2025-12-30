//
//  OpenAIMCPApprovalRequest.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: MCPApprovalRequest, version 2.3.0, line 45637
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-mcp_approval_request
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-mcp_approval_request

/// A request for human approval of a tool invocation.
nonisolated public struct OpenAIMCPApprovalRequest: Codable, Sendable {
    /// A JSON string of arguments for the tool.
    public let arguments: [String: AIProxyJSONValue]

    /// The unique ID of the approval request.
    public let id: String
    
    /// The name of the tool to run.
    public let name: String
    
    /// The label of the MCP server making the request.
    public let serverLabel: String
    
    /// The type of the item. Always `mcp_approval_request`.
    public let type = "mcp_approval_request"
    
    /// Creates a new MCP approval request.
    /// - Parameters:
    ///   - arguments: A JSON string of arguments for the tool.
    ///   - id: The unique ID of the approval request.
    ///   - name: The name of the tool to run.
    ///   - serverLabel: The label of the MCP server making the request.
    public init(
        arguments: [String: AIProxyJSONValue],
        id: String,
        name: String,
        serverLabel: String
    ) {
        self.arguments = arguments
        self.id = id
        self.name = name
        self.serverLabel = serverLabel
    }
    
    private enum CodingKeys: String, CodingKey {
        case arguments
        case id
        case name
        case serverLabel = "server_label"
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(arguments, forKey: .arguments)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(serverLabel, forKey: .serverLabel)
        try container.encode(type, forKey: .type)
    }
}
