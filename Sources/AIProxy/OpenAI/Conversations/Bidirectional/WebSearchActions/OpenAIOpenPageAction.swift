//
//  OpenAIOpenPageAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Action type `open_page` - Opens a specific URL from search results.
nonisolated public struct OpenAIOpenPageAction: Codable, Sendable {
    /// The action type.
    public let type = "open_page"

    /// The URL opened by the model.
    public let url: String

    /// Creates a new open page action.
    /// - Parameters:
    ///   - url: The URL opened by the model.
    public init(url: String) {
        self.url = url
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case url
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}
