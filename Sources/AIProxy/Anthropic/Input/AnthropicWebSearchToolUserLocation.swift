//
//  AnthropicWebSearchToolUserLocation.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// User location for providing more relevant search results.
/// Represents the `user_location` field of Anthropic's `WebSearchTool20250305` object:
/// https://console.anthropic.com/docs/en/api/messages#web_search_tool_20250305
nonisolated public struct AnthropicWebSearchToolUserLocation: Encodable, Sendable {
    /// The city of the user.
    public let city: String?

    /// The two letter ISO country code of the user.
    public let country: String?

    /// The region of the user.
    public let region: String?

    /// The IANA timezone of the user.
    public let timezone: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case city
        case country
        case region
        case timezone
    }

    public init(
        city: String? = nil,
        country: String? = nil,
        region: String? = nil,
        timezone: String? = nil
    ) {
        self.city = city
        self.country = country
        self.region = region
        self.timezone = timezone
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("approximate", forKey: .type)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(country, forKey: .country)
        try container.encodeIfPresent(region, forKey: .region)
        try container.encodeIfPresent(timezone, forKey: .timezone)
    }
}
