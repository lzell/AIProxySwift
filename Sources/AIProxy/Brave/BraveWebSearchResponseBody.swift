//
//  BraveWebSearchResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 2/7/25.
//

import Foundation

/// See this reference:
/// https://api-dashboard.search.brave.com/app/documentation/web-search/responses
nonisolated public struct BraveWebSearchResponseBody: Decodable, Sendable {
    public let mixed: Mixed?
    public let query: Query?
    public let type: String?
    public let web: Web?
    
    public init(mixed: Mixed?, query: Query?, type: String?, web: Web?) {
        self.mixed = mixed
        self.query = query
        self.type = type
        self.web = web
    }
}

extension BraveWebSearchResponseBody {
    nonisolated public struct Query: Decodable, Sendable {
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
        
        public init(badResults: Bool?, city: String?, country: String?, headerCountry: String?, isNavigational: Bool?, isNewsBreaking: Bool?, moreResultsAvailable: Bool?, original: String?, postalCode: String?, shouldFallback: Bool?, showStrictWarning: Bool?, spellcheckOff: Bool?, state: String?) {
            self.badResults = badResults
            self.city = city
            self.country = country
            self.headerCountry = headerCountry
            self.isNavigational = isNavigational
            self.isNewsBreaking = isNewsBreaking
            self.moreResultsAvailable = moreResultsAvailable
            self.original = original
            self.postalCode = postalCode
            self.shouldFallback = shouldFallback
            self.showStrictWarning = showStrictWarning
            self.spellcheckOff = spellcheckOff
            self.state = state
        }

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
    nonisolated public struct Mixed: Decodable, Sendable {
        public let main: [MixedItem]?
        public let side: [MixedItem]?
        public let top: [MixedItem]?
        public let type: String?
        
        public init(main: [MixedItem]?, side: [MixedItem]?, top: [MixedItem]?, type: String?) {
            self.main = main
            self.side = side
            self.top = top
            self.type = type
        }

        nonisolated public struct MixedItem: Decodable, Sendable {
            public let all: Bool
            public let index: Int?
            public let type: String
        }
    }
}

extension BraveWebSearchResponseBody {
    nonisolated public struct Web: Decodable, Sendable {
        public let familyFriendly: Bool?
        public let results: [SearchResult]?
        public let type: String?
        
        public init(familyFriendly: Bool?, results: [SearchResult]?, type: String?) {
            self.familyFriendly = familyFriendly
            self.results = results
            self.type = type
        }

        private enum CodingKeys: String, CodingKey {
            case familyFriendly = "family_friendly"
            case results
            case type
        }
    }
}

extension BraveWebSearchResponseBody.Web {
    nonisolated public struct SearchResult: Decodable, Sendable {
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
        
        public init(age: String?, description: String?, familyFriendly: Bool?, isLive: Bool?, isSourceBoth: Bool?, isSourceLocal: Bool?, language: String?, metaURL: MetaURL?, pageAge: String?, profile: Profile?, subtype: String?, title: String?, type: String?, thumbnail: Thumbnail?, url: String?) {
            self.age = age
            self.description = description
            self.familyFriendly = familyFriendly
            self.isLive = isLive
            self.isSourceBoth = isSourceBoth
            self.isSourceLocal = isSourceLocal
            self.language = language
            self.metaURL = metaURL
            self.pageAge = pageAge
            self.profile = profile
            self.subtype = subtype
            self.title = title
            self.type = type
            self.thumbnail = thumbnail
            self.url = url
        }

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
    nonisolated public struct Profile: Decodable, Sendable {
        public let img: String?
        public let longName: String?
        public let name: String?
        public let url: String?
        
        public init(img: String?, longName: String?, name: String?, url: String?) {
            self.img = img
            self.longName = longName
            self.name = name
            self.url = url
        }

        private enum CodingKeys: String, CodingKey {
            case img
            case longName = "long_name"
            case name
            case url
        }
    }
}

extension BraveWebSearchResponseBody.Web.SearchResult {
    nonisolated public struct MetaURL: Decodable, Sendable {
        public let favicon: String?
        public let hostname: String?
        public let netloc: String?
        public let path: String?
        public let scheme: String?
        
        public init(favicon: String?, hostname: String?, netloc: String?, path: String?, scheme: String?) {
            self.favicon = favicon
            self.hostname = hostname
            self.netloc = netloc
            self.path = path
            self.scheme = scheme
        }

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
    nonisolated public struct Thumbnail: Decodable, Sendable {
        public let logo: Bool?
        public let original: String?
        public let src: String?

        private enum CodingKeys: String, CodingKey {
            case logo
            case original
            case src
        }
        
        public init(logo: Bool?, original: String?, src: String?) {
            self.logo = logo
            self.original = original
            self.src = src
        }
    }
}
