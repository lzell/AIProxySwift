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
        let sampleResponse = """
        {
            "candidates": [
                {
                "content": {
                    "parts": [
                    {
                        "text": "Why don't scientists trust atoms? \n\nBecause they make up everything! \n"
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
        """
        let body = GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(body.candidates?.first?.content?.parts?.first?.text, "Why don't scientists trust atoms")
    }
}