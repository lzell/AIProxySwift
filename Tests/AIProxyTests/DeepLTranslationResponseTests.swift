//
//  DeepLTranslationResponseTests.swift
//
//
//  Created by Lou Zell on 8/3/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class DeepLTranslationResponseTests: XCTestCase {

    func testResponseBodyIsDecodable() {
        let sampleResponse = """
            {"translations":[{"detected_source_language":"EN","text":"hola mundo"}]}
        """
        let translationModel = try! JSONDecoder().decode(
            DeepLTranslateResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )

        XCTAssertEqual("hola mundo", translationModel.translations.first!.text)
    }
}
