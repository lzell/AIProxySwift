//
//  OpenAIConversationsItemList.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A list of conversation items.
///
/// See: https://platform.openai.com/docs/api-reference/conversations/list-items
nonisolated public struct OpenAIConversationsItemList: Decodable, Sendable {
    /// The type of object returned, which is always `list`.
    public let object: String

    /// A list of conversation items.
    public let data: [OpenAIConversationsItem]

    /// Whether there are more items available.
    public let hasMore: Bool

    /// The ID of the first item in the list.
    public let firstId: String

    /// The ID of the last item in the list.
    public let lastId: String

    private enum CodingKeys: String, CodingKey {
        case object
        case data
        case hasMore = "has_more"
        case firstId = "first_id"
        case lastId = "last_id"
    }
}
