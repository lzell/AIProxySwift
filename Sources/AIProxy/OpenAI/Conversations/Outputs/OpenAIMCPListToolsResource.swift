//
//  OpenAIMCPListToolsResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: MCPListTools, version 2.3.0, line 12026

/// A list of tools available on an MCP server.
nonisolated public struct OpenAIMCPListToolsResource: Decodable, Sendable {
    /// The unique ID of the list.
    public let id: String

    /// The label of the MCP server.
    public let serverLabel: String

    /// The tools available on the server.
    public let tools: [OpenAIMCPListToolsTool]

    /// The type of the item. Always `mcp_list_tools`.
    public let type: String

    /// Error message if the server could not list tools.
    public let error: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case serverLabel = "server_label"
        case tools
        case type
        case error
    }
}

/// A tool available on an MCP server.
nonisolated public struct OpenAIMCPListToolsTool: Decodable, Sendable {
    /// The JSON schema describing the tool's input.
    public let inputSchema: [String: AIProxyJSONValue]

    /// The name of the tool.
    public let name: String

    /// Additional annotations about the tool.
    public let annotations: [String: AIProxyJSONValue]?

    /// The description of the tool.
    public let description: String?

    private enum CodingKeys: String, CodingKey {
        case inputSchema = "input_schema"
        case name
        case annotations
        case description
    }
}
