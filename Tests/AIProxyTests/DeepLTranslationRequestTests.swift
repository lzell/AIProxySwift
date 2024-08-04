//
//  DeepLTranslationRequestTests.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class DeepLTranslationRequestTests: XCTestCase {

    func testBasicRequestBodyIsEncodable() {
        let translationRequestBody = DeepLTranslateRequestBody(
            targetLang: "ES",
            text: ["hello world"]
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let jsonData = try! encoder.encode(translationRequestBody)
        XCTAssertEqual(
            #"{"target_lang":"ES","text":["hello world"]}"#,
            String(data: jsonData, encoding: .utf8)!
        )
    }

    func testFullyPopulatedRequestBodyIsEncodable() {
        let translationRequestBody = DeepLTranslateRequestBody(
            targetLang: "ES",
            text: ["hello world"],
            context: "this is context",
            formality: .preferLess,
            glossaryID: "123",
            ignoreTags: ["<div>"],
            nonSplittingTags: ["<div>"],
            outlineDetection: true,
            preserveFormatting: true,
            sourceLang: "EN",
            splitSentences: .punctuation,
            splittingTags: ["<br>"],
            tagHandling: .xml
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let jsonData = try! encoder.encode(translationRequestBody)
        XCTAssertEqual(
            #"{"context":"this is context","formality":"prefer_less","glossary_id":"123","ignore_tags":["<div>"],"non_splitting_tags":["<div>"],"outline_detection":true,"preserve_formatting":true,"source_lang":"EN","split_sentences":"nonewlines","splitting_tags":["<br>"],"tag_handling":"xml","target_lang":"ES","text":["hello world"]}"#,
            String(data: jsonData, encoding: .utf8)!
        )
    }

}
