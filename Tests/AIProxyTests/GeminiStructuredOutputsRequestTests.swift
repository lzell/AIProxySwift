//
//  GeminiStructuredOutputsRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 3/15/25.
//

import XCTest
import Foundation
@testable import AIProxy


final class GeminiStructuredOutputsRequestTests: XCTestCase {
    // This example is from generative-ai-js/samples/controlled_generation.js
    func testRequestIsEncodableToJson() throws {
        let schema: [String: AIProxyJSONValue] = [
            "description": "List of recipes",
            "type": "array",
            "items": [
                "type": "object",
                "properties": [
                    "recipeName": [
                        "type": "string",
                        "description": "Name of the recipe",
                        "nullable": false
                    ]
                ],
                "required": ["recipeName"]
            ]
        ]

        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("List a few popular cookie recipes.")],
                    role: "user"
                )
            ],
            generationConfig: .init(
                responseMimeType: "application/json",
                responseSchema: schema
            )
        )
        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "List a few popular cookie recipes."
                    }
                  ],
                  "role" : "user"
                }
              ],
              "generationConfig" : {
                "responseMimeType" : "application\/json",
                "responseSchema" : {
                  "description" : "List of recipes",
                  "items" : {
                    "properties" : {
                      "recipeName" : {
                        "description" : "Name of the recipe",
                        "nullable" : false,
                        "type" : "string"
                      }
                    },
                    "required" : [
                      "recipeName"
                    ],
                    "type" : "object"
                  },
                  "type" : "array"
                }
              }
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }
}
