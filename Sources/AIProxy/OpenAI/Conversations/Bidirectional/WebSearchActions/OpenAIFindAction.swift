//
//  OpenAIFindAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Action type "find": Searches for a pattern within a loaded page.
nonisolated public struct OpenAIFindAction: Codable, Sendable {
    /// The pattern or text to search for within the page.
    public let pattern: String

    /// The action type.
    public let type = "find"

    /// The URL of the page searched for the pattern.
    public let url: String

    /// Creates a new find action.
    /// - Parameters:
    ///   - pattern: The pattern or text to search for within the page.
    ///   - url: The URL of the page searched for the pattern.
    public init(
        pattern: String,
        url: String
    ) {
        self.pattern = pattern
        self.url = url
    }

    private enum CodingKeys: String, CodingKey {
        case pattern
        case type
        case url
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}
