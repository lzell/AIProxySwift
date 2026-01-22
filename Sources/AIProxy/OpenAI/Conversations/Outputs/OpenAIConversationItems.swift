//
//  OpenAIConversationItems.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ConversationItemList, version 2.3.0, line 36153
// https://platform.openai.com/docs/api-reference/conversations/list-items-object

/// A list of Conversation items.
nonisolated public struct OpenAIConversationItems: Decodable, Sendable {
    /// A list of conversation items.
    public let data: [OpenAIConversationItem]
    
    /// The ID of the first item in the list.
    public let firstID: String
    
    /// Whether there are more items available.
    public let hasMore: Bool
    
    /// The ID of the last item in the list.
    public let lastID: String
    
    /// The type of object returned, must be `list`.
    public let object = "list"

    /// Creates a new conversation item list.
    /// - Parameters:
    ///   - data: A list of conversation items.
    ///   - firstID: The ID of the first item in the list.
    ///   - hasMore: Whether there are more items available.
    ///   - lastID: The ID of the last item in the list.
    public init(
        data: [OpenAIConversationItem],
        firstID: String,
        hasMore: Bool,
        lastID: String
    ) {
        self.data = data
        self.firstID = firstID
        self.hasMore = hasMore
        self.lastID = lastID
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
        case firstID = "first_id"
        case hasMore = "has_more"
        case lastID = "last_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([OpenAIConversationItem].self, forKey: .data)
        self.firstID = try container.decode(String.self, forKey: .firstID)
        self.hasMore = try container.decode(Bool.self, forKey: .hasMore)
        self.lastID = try container.decode(String.self, forKey: .lastID)
    }
}
