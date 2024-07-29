//
//  StabilityAIRequestTests.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

import Foundation

import XCTest
import Foundation
@testable import AIProxy


final class StabilityAIRequestTests: XCTestCase {

    func testUtraBodyIsFormEncodable() {
        let body = StabilityAIUltraRequestBody(
            prompt: "lighthouse",
            aspectRatio: "9:16",
            negativePrompt: "No moon",
            outputFormat: .jpeg
        )

        let boundary = UUID().uuidString
        let result = formEncode(body, boundary)

        let expected = """
        --\(boundary)\r
        Content-Disposition: form-data; name="prompt"\r
        \r
        lighthouse\r
        --\(boundary)\r
        Content-Disposition: form-data; name="aspect_ratio"\r
        \r
        9:16\r
        --\(boundary)\r
        Content-Disposition: form-data; name="negative_prompt"\r
        \r
        No moon\r
        --\(boundary)\r
        Content-Disposition: form-data; name="output_format"\r
        \r
        jpeg\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }
}
