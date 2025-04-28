//
//  GeminiGroundingRequestBodyTests.swift
//  AIProxy
//
//  Created by Lou Zell on 1/3/25.
//


import XCTest
import Foundation
@testable import AIProxy


final class GeminiGenerateContentRequestTests: XCTestCase {

    func testGroundingRequestIsEncodableToJson() throws {
        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("What is the price of Google stock today")],
                    role: "user"
                )
            ],
            tools: [
                .googleSearchRetrieval(.init(dynamicThreshold: 0.7, mode: .dynamic))
            ]
        )
        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "What is the price of Google stock today"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "tools" : [
                {
                  "googleSearchRetrieval" : {
                    "dynamicRetrievalConfig" : {
                      "dynamicThreshold" : 0.7,
                      "mode" : "MODE_DYNAMIC"
                    }
                  }
                }
              ]
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }
    
    func testGroundingRequestWithGoogleSearchIsEncodableToJson() throws {
        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("What is the price of Google stock today")],
                    role: "user"
                )
            ],
            tools: [
                .googleSearch(GeminiGenerateContentRequestBody.GoogleSearch())
            ]
        )
        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "What is the price of Google stock today"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "tools" : [
                {
                  "googleSearch" : {

                  }
                }
              ]
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }

    func testRequestWithSystemInstructionIsEncodable() throws {
        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("What is a computer?")],
                    role: "user"
                )
            ],
            systemInstruction: .init(parts: [.text("You speak only in jargon")])
        )

        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "What is a computer?"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "systemInstruction" : {
                "parts" : [
                  {
                    "text" : "You speak only in jargon"
                  }
                ],
                "role" : "system"
              }
            }
            """#,
            try requestBody.serialize(pretty: true)
        )

    }

    func testFunctionRequestIsEncodableToJson() throws {

        let schema: [String: AIProxyJSONValue] = [
            "type": "OBJECT",
            "properties": [
                "brightness": [
                    "description": "Light level from 0 to 100. Zero is off and 100 is full brightness.",
                    "type": "NUMBER"
                ],
                "colorTemperature": [
                    "description": "Color temperature of the light fixture which can be `daylight`, `cool` or `warm`.",
                    "type": "STRING"
                ]
            ],
            "required": [
                "brightness",
                "colorTemperature"
            ]
        ]

        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("Dim the lights so the room feels cozy and warm.")],
                    role: "user"
                )
            ],
            tools: [
                .functionDeclarations([
                    .init(name: "controlLight", description: "Set the brightness and color temperature of a room light.", parameters: schema)
                ])
            ]
        )
        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "Dim the lights so the room feels cozy and warm."
                    }
                  ],
                  "role" : "user"
                }
              ],
              "tools" : [
                {
                  "functionDeclarations" : [
                    {
                      "description" : "Set the brightness and color temperature of a room light.",
                      "name" : "controlLight",
                      "parameters" : {
                        "properties" : {
                          "brightness" : {
                            "description" : "Light level from 0 to 100. Zero is off and 100 is full brightness.",
                            "type" : "NUMBER"
                          },
                          "colorTemperature" : {
                            "description" : "Color temperature of the light fixture which can be `daylight`, `cool` or `warm`.",
                            "type" : "STRING"
                          }
                        },
                        "required" : [
                          "brightness",
                          "colorTemperature"
                        ],
                        "type" : "OBJECT"
                      }
                    }
                  ]
                }
              ]
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }

    func testRequestWithThinkingConfigIsEncodable() throws {
        let requestBody = GeminiGenerateContentRequestBody(
            contents: [
                .init(
                    parts: [.text("Explain the Occam's Razor concept and provide everyday examples of it")],
                    role: "user"
                )
            ],
            generationConfig: .init(
                maxOutputTokens: 200,
                temperature: 0.7,
                thinkingConfig: .init(thinkingBudget: 1024)
            )
        )

        XCTAssertEqual(#"""
            {
              "contents" : [
                {
                  "parts" : [
                    {
                      "text" : "Explain the Occam's Razor concept and provide everyday examples of it"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "generationConfig" : {
                "maxOutputTokens" : 200,
                "temperature" : 0.7,
                "thinkingConfig" : {
                  "thinkingBudget" : 1024
                }
              }
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }
}



