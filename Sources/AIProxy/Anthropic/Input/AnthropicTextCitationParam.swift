//
//  AnthropicTextCitationParam.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// A citation reference for text content.
///
/// Citations supporting the text block. The type of citation returned will depend on the type of
/// document being cited. Citing a PDF results in `pageLocation`, plain text results in `charLocation`,
/// and content document results in `contentBlockLocation`.
nonisolated public enum AnthropicTextCitationParam: Encodable, Sendable {
    case charLocation(CharLocation)
    case pageLocation(PageLocation)
    case contentBlockLocation(ContentBlockLocation)
    case webSearchResultLocation(WebSearchResultLocation)
    case searchResultLocation(SearchResultLocation)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .charLocation(let value):
            try value.encode(to: encoder)
        case .pageLocation(let value):
            try value.encode(to: encoder)
        case .contentBlockLocation(let value):
            try value.encode(to: encoder)
        case .webSearchResultLocation(let value):
            try value.encode(to: encoder)
        case .searchResultLocation(let value):
            try value.encode(to: encoder)
        }
    }
}

extension AnthropicTextCitationParam {
    /// Citation with character-based location in a plain text document.
    nonisolated public struct CharLocation: Encodable, Sendable {
        /// The text that was cited.
        public let citedText: String

        /// The index of the document being cited.
        public let documentIndex: Int

        /// The title of the document being cited.
        public let documentTitle: String

        /// The starting character index of the citation.
        public let startCharIndex: Int

        /// The ending character index of the citation.
        public let endCharIndex: Int

        private enum CodingKeys: String, CodingKey {
            case type
            case citedText = "cited_text"
            case documentIndex = "document_index"
            case documentTitle = "document_title"
            case startCharIndex = "start_char_index"
            case endCharIndex = "end_char_index"
        }

        public init(
            citedText: String,
            documentIndex: Int,
            documentTitle: String,
            startCharIndex: Int,
            endCharIndex: Int
        ) {
            self.citedText = citedText
            self.documentIndex = documentIndex
            self.documentTitle = documentTitle
            self.startCharIndex = startCharIndex
            self.endCharIndex = endCharIndex
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("char_location", forKey: .type)
            try container.encode(citedText, forKey: .citedText)
            try container.encode(documentIndex, forKey: .documentIndex)
            try container.encode(documentTitle, forKey: .documentTitle)
            try container.encode(startCharIndex, forKey: .startCharIndex)
            try container.encode(endCharIndex, forKey: .endCharIndex)
        }
    }

    /// Citation with page-based location in a PDF document.
    nonisolated public struct PageLocation: Encodable, Sendable {
        /// The text that was cited.
        public let citedText: String

        /// The index of the document being cited.
        public let documentIndex: Int

        /// The title of the document being cited.
        public let documentTitle: String

        /// The starting page number of the citation.
        public let startPageNumber: Int

        /// The ending page number of the citation.
        public let endPageNumber: Int

        private enum CodingKeys: String, CodingKey {
            case type
            case citedText = "cited_text"
            case documentIndex = "document_index"
            case documentTitle = "document_title"
            case startPageNumber = "start_page_number"
            case endPageNumber = "end_page_number"
        }

        public init(
            citedText: String,
            documentIndex: Int,
            documentTitle: String,
            startPageNumber: Int,
            endPageNumber: Int
        ) {
            self.citedText = citedText
            self.documentIndex = documentIndex
            self.documentTitle = documentTitle
            self.startPageNumber = startPageNumber
            self.endPageNumber = endPageNumber
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("page_location", forKey: .type)
            try container.encode(citedText, forKey: .citedText)
            try container.encode(documentIndex, forKey: .documentIndex)
            try container.encode(documentTitle, forKey: .documentTitle)
            try container.encode(startPageNumber, forKey: .startPageNumber)
            try container.encode(endPageNumber, forKey: .endPageNumber)
        }
    }

    /// Citation with content block-based location.
    nonisolated public struct ContentBlockLocation: Encodable, Sendable {
        /// The text that was cited.
        public let citedText: String

        /// The index of the document being cited.
        public let documentIndex: Int

        /// The title of the document being cited.
        public let documentTitle: String

        /// The starting content block index of the citation.
        public let startBlockIndex: Int

        /// The ending content block index of the citation.
        public let endBlockIndex: Int

        private enum CodingKeys: String, CodingKey {
            case type
            case citedText = "cited_text"
            case documentIndex = "document_index"
            case documentTitle = "document_title"
            case startBlockIndex = "start_block_index"
            case endBlockIndex = "end_block_index"
        }

        public init(
            citedText: String,
            documentIndex: Int,
            documentTitle: String,
            startBlockIndex: Int,
            endBlockIndex: Int
        ) {
            self.citedText = citedText
            self.documentIndex = documentIndex
            self.documentTitle = documentTitle
            self.startBlockIndex = startBlockIndex
            self.endBlockIndex = endBlockIndex
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("content_block_location", forKey: .type)
            try container.encode(citedText, forKey: .citedText)
            try container.encode(documentIndex, forKey: .documentIndex)
            try container.encode(documentTitle, forKey: .documentTitle)
            try container.encode(startBlockIndex, forKey: .startBlockIndex)
            try container.encode(endBlockIndex, forKey: .endBlockIndex)
        }
    }

    /// Citation from a web search result.
    nonisolated public struct WebSearchResultLocation: Encodable, Sendable {
        /// The text that was cited.
        public let citedText: String

        /// The encrypted index of the web search result.
        public let encryptedIndex: String

        /// The title of the web search result.
        public let title: String

        /// The URL of the web search result.
        public let url: String

        private enum CodingKeys: String, CodingKey {
            case type
            case citedText = "cited_text"
            case encryptedIndex = "encrypted_index"
            case title
            case url
        }

        public init(
            citedText: String,
            encryptedIndex: String,
            title: String,
            url: String
        ) {
            self.citedText = citedText
            self.encryptedIndex = encryptedIndex
            self.title = title
            self.url = url
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("web_search_result_location", forKey: .type)
            try container.encode(citedText, forKey: .citedText)
            try container.encode(encryptedIndex, forKey: .encryptedIndex)
            try container.encode(title, forKey: .title)
            try container.encode(url, forKey: .url)
        }
    }

    /// Citation from a search result.
    nonisolated public struct SearchResultLocation: Encodable, Sendable {
        /// The text that was cited.
        public let citedText: String

        /// The index of the search result being cited.
        public let searchResultIndex: Int

        /// The source of the search result.
        public let source: String

        /// The title of the search result.
        public let title: String

        /// The starting content block index of the citation.
        public let startBlockIndex: Int

        /// The ending content block index of the citation.
        public let endBlockIndex: Int

        private enum CodingKeys: String, CodingKey {
            case type
            case citedText = "cited_text"
            case searchResultIndex = "search_result_index"
            case source
            case title
            case startBlockIndex = "start_block_index"
            case endBlockIndex = "end_block_index"
        }

        public init(
            citedText: String,
            searchResultIndex: Int,
            source: String,
            title: String,
            startBlockIndex: Int,
            endBlockIndex: Int
        ) {
            self.citedText = citedText
            self.searchResultIndex = searchResultIndex
            self.source = source
            self.title = title
            self.startBlockIndex = startBlockIndex
            self.endBlockIndex = endBlockIndex
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("search_result_location", forKey: .type)
            try container.encode(citedText, forKey: .citedText)
            try container.encode(searchResultIndex, forKey: .searchResultIndex)
            try container.encode(source, forKey: .source)
            try container.encode(title, forKey: .title)
            try container.encode(startBlockIndex, forKey: .startBlockIndex)
            try container.encode(endBlockIndex, forKey: .endBlockIndex)
        }
    }
}
