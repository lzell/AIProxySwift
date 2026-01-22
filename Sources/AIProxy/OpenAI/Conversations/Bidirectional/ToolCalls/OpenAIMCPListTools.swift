//
//  OpenAIMCPListTools.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// OpenAPI spec: MCPListTools, version 2.3.0, line 45747
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-mcp_list_tools

/// A list of tools available on an MCP server.
nonisolated public struct OpenAIMCPListTools: Codable, Sendable {
    /// The unique ID of the list.
    public let id: String

    /// The label of the MCP server.
    public let serverLabel: String

    /// The tools available on the server.
    public let tools: [OpenAIMCPListTools.Tool]

    /// The type of the item. Always `mcp_list_tools`.
    public let type = "mcp_list_tools"
    
    /// Error message if the server could not list tools.
    public let error: String?

    /// Creates a new MCP list tools.
    /// - Parameters:
    ///   - id: The unique ID of the list.
    ///   - serverLabel: The label of the MCP server.
    ///   - tools: The tools available on the server.
    ///   - error: Error message if the server could not list tools.
    public init(
        id: String,
        serverLabel: String,
        tools: [OpenAIMCPListTools.Tool],
        error: String? = nil
    ) {
        self.id = id
        self.serverLabel = serverLabel
        self.tools = tools
        self.error = error
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case serverLabel = "server_label"
        case tools
        case type
        case error
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(serverLabel, forKey: .serverLabel)
        try container.encode(tools, forKey: .tools)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(error, forKey: .error)
    }
}


// OpenAPI spec: MCPListToolsTool, version 2.3.0, line 45785
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-mcp_list_tools-tools
/// A tool available on an MCP server.
extension OpenAIMCPListTools {
    nonisolated public struct Tool: Codable, Sendable {
        /// The JSON schema describing the tool's input.
        public let inputSchema: [String: AIProxyJSONValue]

        /// The name of the tool.
        public let name: String

        /// Additional annotations about the tool.
        public let annotations: [String: AIProxyJSONValue]?

        /// The description of the tool.
        public let description: String?

        /// Creates a new MCP list tools tool.
        /// - Parameters:
        ///   - inputSchema: The JSON schema describing the tool's input.
        ///   - name: The name of the tool.
        ///   - annotations: Additional annotations about the tool.
        ///   - description: The description of the tool.
        public init(
            inputSchema: [String: AIProxyJSONValue],
            name: String,
            annotations: [String: AIProxyJSONValue]? = nil,
            description: String? = nil
        ) {
            self.inputSchema = inputSchema
            self.name = name
            self.annotations = annotations
            self.description = description
        }

        private enum CodingKeys: String, CodingKey {
            case inputSchema = "input_schema"
            case name
            case annotations
            case description
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(inputSchema, forKey: .inputSchema)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(annotations, forKey: .annotations)
            try container.encodeIfPresent(description, forKey: .description)
        }
    }
}
