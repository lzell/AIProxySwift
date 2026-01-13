//
//  OpenAIConversationsService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

@AIProxyActor public class OpenAIConversationsService: Sendable {
    private let requestBuilder: AIProxyRequestBuilder
    private let serviceNetworker: ServiceMixin

    /// This designated initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.openaiConversationsService` or
    /// `AIProxy.openaiConversationsDirectService` defined in AIProxy.swift.
    nonisolated init(o
        requestBuilder: AIProxyRequestBuilder,
        serviceNetworker: ServiceMixin
    ) {
        self.requestBuilder = requestBuilder
        self.serviceNetworker = serviceNetworker
    }

    // MARK: - Conversation CRUD

    /// Creates a new conversation.
    ///
    /// - Parameters:
    ///   - body: The create conversation request body
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The created conversation resource
    public func createConversation(
        body: OpenAIConversationsCreateRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsResource {
        let request = try await self.requestBuilder.jsonPOST(
            path: "/v1/conversations",
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Retrieves a conversation by ID.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation to retrieve
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The conversation resource
    public func getConversation(
        conversationID: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsResource {
        let request = try await self.requestBuilder.plainGET(
            path: "/v1/conversations/\(conversationID)",
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Updates a conversation's metadata.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation to update
    ///   - body: The update request body containing new metadata
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The updated conversation resource
    public func updateConversation(
        conversationID: String,
        body: OpenAIConversationsUpdateRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsResource {
        let request = try await self.requestBuilder.jsonPOST(
            path: "/v1/conversations/\(conversationID)",
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Deletes a conversation.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation to delete
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The deleted conversation resource
    public func deleteConversation(
        conversationID: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsDeletedResource {
        let request = try await self.requestBuilder.plainDELETE(
            path: "/v1/conversations/\(conversationID)",
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    // MARK: - Item CRUD

    /// Lists items in a conversation.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation
    ///   - limit: Maximum number of items to return (1-100, default 20)
    ///   - order: Sort order (asc or desc, default desc)
    ///   - after: Cursor for pagination
    ///   - include: Additional fields to include in the response
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: A list of conversation items
    public func listItems(
        conversationID: String,
        limit: Int? = nil,
        order: OpenAIConversationsOrderParam? = nil,
        after: String? = nil,
        include: [OpenAIConversationsIncludeParam]? = nil,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsItemList {
        let path = Self.buildPath(
            base: "/v1/conversations/\(conversationID)/items",
            limit: limit,
            order: order,
            after: after,
            include: include
        )

        let request = try await self.requestBuilder.plainGET(
            path: path,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Creates items in a conversation.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation
    ///   - body: The create items request body
    ///   - include: Additional fields to include in the response
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: A list of created conversation items
    public func createItems(
        conversationID: String,
        body: OpenAIConversationsCreateItemsRequestBody,
        include: [OpenAIConversationsIncludeParam]? = nil,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsItemList {
        let path = Self.buildPath(
            base: "/v1/conversations/\(conversationID)/items",
            include: include
        )

        let request = try await self.requestBuilder.jsonPOST(
            path: path,
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Retrieves a specific item from a conversation.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation
    ///   - itemID: The ID of the item to retrieve
    ///   - include: Additional fields to include in the response
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The conversation item
    public func getItem(
        conversationID: String,
        itemID: String,
        include: [OpenAIConversationsIncludeParam]? = nil,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsItem {
        let path = Self.buildPath(
            base: "/v1/conversations/\(conversationID)/items/\(itemID)",
            include: include
        )

        let request = try await self.requestBuilder.plainGET(
            path: path,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Deletes an item from a conversation.
    ///
    /// - Parameters:
    ///   - conversationID: The ID of the conversation
    ///   - itemID: The ID of the item to delete
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request
    ///
    /// - Returns: The conversation resource
    public func deleteItem(
        conversationID: String,
        itemID: String,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIConversationsResource {
        let request = try await self.requestBuilder.plainDELETE(
            path: "/v1/conversations/\(conversationID)/items/\(itemID)",
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    // MARK: - Private Helpers

    private static func buildPath(
        base: String,
        limit: Int? = nil,
        order: OpenAIConversationsOrderParam? = nil,
        after: String? = nil,
        include: [OpenAIConversationsIncludeParam]? = nil
    ) -> String {
        var queryItems: [String] = []

        if let limit = limit {
            queryItems.append("limit=\(limit)")
        }
        if let order = order {
            queryItems.append("order=\(order.rawValue)")
        }
        if let after = after {
            queryItems.append("after=\(after.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? after)")
        }
        if let include = include {
            for item in include {
                queryItems.append("include[]=\(item.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? item.rawValue)")
            }
        }

        if queryItems.isEmpty {
            return base
        }
        return "\(base)?\(queryItems.joined(separator: "&"))"
    }
}
