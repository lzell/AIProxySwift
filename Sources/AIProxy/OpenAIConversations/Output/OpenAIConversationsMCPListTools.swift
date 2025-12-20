//
//  OpenAIConversationsMCPListTools.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// An MCP list tools item in a conversation.
nonisolated public struct OpenAIConversationsMCPListTools: Decodable, Sendable {
    /// The type of the item, always "mcp_list_tools".
    public let type: String

    /// The unique ID of the MCP list tools item.
    public let id: String

    /// The status of the MCP list tools item.
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
