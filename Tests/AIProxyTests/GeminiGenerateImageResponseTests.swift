//
//  GeminiGenerateImageResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 3/17/25.
//

import XCTest
import Foundation
@testable import AIProxy


final class GeminiGenerateImageResponseTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "inlineData": {
                      "mimeType": "image/png",
                      "data": "<snip>"
                    }
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "index": 0
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 36,
            "totalTokenCount": 36,
            "promptTokensDetails": [
              {
                "modality": "TEXT",
                "tokenCount": 36
              }
            ]
          },
          "modelVersion": "gemini-2.0-flash-exp-image-generation"
        }
        """#

        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        if case .inlineData(mimeType: let mimeType, base64Data: let b64Data) = body.candidates?.first?.content?.parts?.first {
            XCTAssertEqual("image/png", mimeType)
            XCTAssertEqual("<snip>", b64Data)
        } else {
            XCTFail()
        }
    }

}



