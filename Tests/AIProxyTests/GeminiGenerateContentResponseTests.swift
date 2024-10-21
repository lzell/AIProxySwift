//
//  GeminiGenerateContentResponseBodyTests.swift
//
//
//  Created by Todd Hamilton on 10/15/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class GeminiGenerateContentResponseBodyTests: XCTestCase {

    func testUploadFileResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
            "candidates": [
                {
                "content": {
                    "parts": [
                    {
                        "text": "findme"
                    }
                    ],
                    "role": "model"
                },
                "finishReason": "STOP",
                "index": 0,
                "safetyRatings": [
                    {
                    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_HATE_SPEECH",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_HARASSMENT",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                    "probability": "NEGLIGIBLE"
                    }
                ]
                }
            ],
            "usageMetadata": {
                "promptTokenCount": 4,
                "candidatesTokenCount": 16,
                "totalTokenCount": 20
            }
        }
        """#
        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        if case .text(let generated) = body.candidates?.first?.content?.parts?.first {
            XCTAssertEqual(generated, "findme")
        } else {
            XCTFail()
        }
    }
}
