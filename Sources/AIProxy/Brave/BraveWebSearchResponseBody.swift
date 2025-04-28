//
//  BraveWebSearchResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 2/7/25.
//

import Foundation

/// See this reference:
/// https://api-dashboard.search.brave.com/app/documentation/web-search/responses
public struct BraveWebSearchResponseBody: Decodable {
    public let mixed: Mixed?
    public let query: Query?
    public let type: String?
    public let web: Web?
}

extension BraveWebSearchResponseBody {
    public struct Query: Decodable {
        public let badResults: Bool?
        public let city: String?
        public let country: String?
        public let headerCountry: String?
        public let isNavigational: Bool?
        public let isNewsBreaking: Bool?
        public let moreResultsAvailable: Bool?
        public let original: String?
        public let postalCode: String?
        public let shouldFallback: Bool?
        public let showStrictWarning: Bool?
        public let spellcheckOff: Bool?
        public let state: String?

        private enum CodingKeys: String, CodingKey {
            case badResults
            case city
            case country
            case headerCountry = "header_country"
            case isNavigational = "is_navigational"
            case isNewsBreaking = "is_news_breaking"
            case moreResultsAvailable = "more_results_available"
            case original
            case postalCode = "postal_code"
            case shouldFallback
            case showStrictWarning = "show_strict_warning"
            case spellcheckOff = "spellcheck_off"
            case state
        }
    }
}

extension BraveWebSearchResponseBody {
    public struct Mixed: Decodable {
        public let main: [MixedItem]?
        public let side: [MixedItem]?
        public let top: [MixedItem]?
        public let type: String?

        public struct MixedItem: Decodable {
            public let all: Bool
            public let index: Int?
            public let type: String
        }
    }
}

extension BraveWebSearchResponseBody {
    public struct Web: Decodable {
        public let familyFriendly: Bool?
        public let results: [SearchResult]?
        public let type: String?

        private enum CodingKeys: String, CodingKey {
            case familyFriendly = "family_friendly"
            case results
            case type
        }
    }
}

extension BraveWebSearchResponseBody.Web {
    public struct SearchResult: Decodable {
        public let age: String?
        public let description: String?
        public let familyFriendly: Bool?
        public let isLive: Bool?
        public let isSourceBoth: Bool?
        public let isSourceLocal: Bool?
        public let language: String?
        public let metaURL: MetaURL?
        public let pageAge: String?
        public let profile: Profile?
        public let subtype: String?
        public let title: String?
        public let type: String?
        public let thumbnail: Thumbnail?
        public let url: String?

        private enum CodingKeys: String, CodingKey {
            case age
            case description
            case familyFriendly = "family_friendly"
            case isLive = "is_live"
            case isSourceBoth = "is_source_both"
            case isSourceLocal = "is_source_local"
            case language
            case metaURL = "meta_url"
            case pageAge = "page_age"
            case profile
            case subtype
            case title
            case type
            case thumbnail
            case url
        }
    }
}

extension BraveWebSearchResponseBody.Web.SearchResult {
    public struct Profile: Decodable {
        public let img: String?
        public let longName: String?
        public let name: String?
        public let url: String?

        private enum CodingKeys: String, CodingKey {
            case img
            case longName = "long_name"
            case name
            case url
        }
    }
}

extension BraveWebSearchResponseBody.Web.SearchResult {
    public struct MetaURL: Decodable {
        public let favicon: String?
        public let hostname: String?
        public let netloc: String?
        public let path: String?
        public let scheme: String?

        private enum CodingKeys: String, CodingKey {
            case favicon
            case hostname
            case netloc
            case path
            case scheme
        }
    }
}

extension BraveWebSearchResponseBody.Web.SearchResult {
    public struct Thumbnail: Decodable {
        public let logo: Bool?
        public let original: String?
        public let src: String?

        private enum CodingKeys: String, CodingKey {
            case logo
            case original
            case src
        }
    }
}
