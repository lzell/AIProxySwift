//
//  AnthropicWebSearchTool20250305.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Web search tool for searching the web (version 2025-03-05).
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_20250305
nonisolated public struct AnthropicWebSearchTool20250305: Encodable, Sendable {
    /// If provided, only these domains will be included in results.
    /// Cannot be used alongside `blockedDomains`.
    public let allowedDomains: [String]?

    /// If provided, these domains will never appear in results.
    /// Cannot be used alongside `allowedDomains`.
    public let blockedDomains: [String]?

    /// Cache control configuration.
    public let cacheControl: AnthropicCacheControlEphemeral?

    /// Maximum number of times the tool can be used in the API request.
    public let maxUses: Int?

    /// Parameters for the user's location. Used to provide more relevant search results.
    public let userLocation: AnthropicWebSearchToolUserLocation?

    private enum CodingKeys: String, CodingKey {
        case name
        case type
        case allowedDomains = "allowed_domains"
        case blockedDomains = "blocked_domains"
        case cacheControl = "cache_control"
        case maxUses = "max_uses"
        case userLocation = "user_location"
    }

    public init(
        allowedDomains: [String]? = nil,
        blockedDomains: [String]? = nil,
        cacheControl: AnthropicCacheControlEphemeral? = nil,
        maxUses: Int? = nil,
        userLocation: AnthropicWebSearchToolUserLocation? = nil
    ) {
        self.allowedDomains = allowedDomains
        self.blockedDomains = blockedDomains
        self.cacheControl = cacheControl
        self.maxUses = maxUses
        self.userLocation = userLocation
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("web_search", forKey: .name)
        try container.encode("web_search_20250305", forKey: .type)
        try container.encodeIfPresent(allowedDomains, forKey: .allowedDomains)
        try container.encodeIfPresent(blockedDomains, forKey: .blockedDomains)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
        try container.encodeIfPresent(maxUses, forKey: .maxUses)
        try container.encodeIfPresent(userLocation, forKey: .userLocation)
    }
}
