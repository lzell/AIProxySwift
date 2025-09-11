//
//  DeepLTranslateResponseBody.swift
//
//
//  Created by Lou Zell on 8/3/24.
//

import Foundation

/// All docstrings on this model are from:
/// https://developers.deepl.com/docs/api-reference/translate/openapi-spec-for-text-translation
nonisolated public struct DeepLTranslateResponseBody: Decodable, Sendable {
    public let translations: [DeepLTranslation]
    
    public init(translations: [DeepLTranslation]) {
        self.translations = translations
    }
}

nonisolated public struct DeepLTranslation: Decodable, Sendable {
    /// The language detected in the source text. It reflects the value of the `source_lang` parameter, when specified.
    /// Example: "EN"
    public let detectedSourceLanguage: String

    /// The translated text.
    /// Example: "Hallo, Welt!"
    public let text: String
    
    public init(detectedSourceLanguage: String, text: String) {
        self.detectedSourceLanguage = detectedSourceLanguage
        self.text = text
    }

    private enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage = "detected_source_language"
        case text
    }
}
