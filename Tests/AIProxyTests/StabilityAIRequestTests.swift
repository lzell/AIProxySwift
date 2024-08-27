//
//  StabilityAIRequestTests.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

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

    func testStableDiffusionTextToImageBodyIsFormEncodable() {
        let body = StabilityAIStableDiffusionRequestBody(
            prompt: "lighthouse",
            mode: .textToImage
        )

        let boundary = UUID().uuidString
        let result = formEncode(body, boundary)

        let expected = """
        --\(boundary)\r
        Content-Disposition: form-data; name="prompt"\r
        \r
        lighthouse\r
        --\(boundary)\r
        Content-Disposition: form-data; name="mode"\r
        \r
        text-to-image\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }

    func testStableDiffusionImageToImageBodyIsFormEncodable() {
        let body = StabilityAIStableDiffusionRequestBody(
            prompt: "lighthouse",
            image: Data([0x61]),
            mode: .imageToImage,
            strength: 0.5
        )

        let boundary = UUID().uuidString
        let result = formEncode(body, boundary)

        let expected = """
        --\(boundary)\r
        Content-Disposition: form-data; name="prompt"\r
        \r
        lighthouse\r
        --\(boundary)\r
        Content-Disposition: form-data; name="image"; filename="aiproxy.m4a"\r
        Content-Type: image/jpeg\r
        \r
        a\r
        --\(boundary)\r
        Content-Disposition: form-data; name="mode"\r
        \r
        image-to-image\r
        --\(boundary)\r
        Content-Disposition: form-data; name="strength"\r
        \r
        0.5\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }
}
