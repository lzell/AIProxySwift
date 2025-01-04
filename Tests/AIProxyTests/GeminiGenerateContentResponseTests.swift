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

    func testResponseIsDecodable() throws {
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

    func testToolCallResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "functionCall": {
                      "name": "controlLight",
                      "args": {
                        "brightness": 50,
                        "colorTemperature": "cool"
                      }
                    }
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "safetyRatings": [
                {
                  "category": "HARM_CATEGORY_HATE_SPEECH",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_HARASSMENT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                  "probability": "NEGLIGIBLE"
                }
              ],
              "avgLogprobs": -0.09892001748085022
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 98,
            "candidatesTokenCount": 6,
            "totalTokenCount": 104
          },
          "modelVersion": "gemini-2.0-flash-exp"
        }
        """#
        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        if case let .functionCall(name: name, args: args) = body.candidates?.first?.content?.parts?.first {
            XCTAssertEqual("controlLight", name)
            XCTAssertEqual(50, args!["brightness"] as? Int)
            XCTAssertEqual("cool", args!["colorTemperature"] as? String)
        } else {
            XCTFail()
        }
    }
}
