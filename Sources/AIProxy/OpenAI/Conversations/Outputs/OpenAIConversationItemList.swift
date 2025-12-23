//
//  OpenAIConversationItemList.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ConversationItemList, version 2.3.0, line 36153

/// A list of Conversation items.
nonisolated public struct OpenAIConversationItemList: Decodable, Sendable {
    /// A list of conversation items.
    public let data: [ConversationItem]
    
    /// The ID of the first item in the list.
    public let firstID: String
    
    /// Whether there are more items available.
    public let hasMore: Bool
    
    /// The ID of the last item in the list.
    public let lastID: String
    
    /// The type of object returned, must be `list`.
    public let object: String
    
    /// Creates a new conversation item list.
    /// - Parameters:
    ///   - data: A list of conversation items.
    ///   - firstID: The ID of the first item in the list.
    ///   - hasMore: Whether there are more items available.
    ///   - lastID: The ID of the last item in the list.
    ///   - object: The type of object returned, must be `list`.
    public init(
        data: [ConversationItem],
        firstID: String,
        hasMore: Bool,
        lastID: String,
        object: String
    ) {
        self.data = data
        self.firstID = firstID
        self.hasMore = hasMore
        self.lastID = lastID
        self.object = object
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
        case firstID = "first_id"
        case hasMore = "has_more"
        case lastID = "last_id"
        case object
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([ConversationItem].self, forKey: .data)
        self.firstID = try container.decode(String.self, forKey: .firstID)
        self.hasMore = try container.decode(Bool.self, forKey: .hasMore)
        self.lastID = try container.decode(String.self, forKey: .lastID)
        self.object = try container.decode(String.self, forKey: .object)
    }
}
