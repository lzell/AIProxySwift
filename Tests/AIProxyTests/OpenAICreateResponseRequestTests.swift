//
//  OpenAICreateResponseRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 3/27/25.
//

import XCTest
@testable import AIProxy

final class OpenAICreateResponseRequestTests: XCTestCase {

    func testResponseRequestIsEncodableWithFileUse() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .list([
                            .file(fileID: "file-XC5txiSNGrMiP1uMb7R2HT"),
                            .text("What is the purpose of this doc?")
                        ])
                    ),
                ]
            ),
            model: "gpt-4o"
        )
        XCTAssertEqual(
            """
            {
              "input" : [
                {
                  "content" : [
                    {
                      "file_id" : "file-XC5txiSNGrMiP1uMb7R2HT",
                      "type" : "input_file"
                    },
                    {
                      "text" : "What is the purpose of this doc?",
                      "type" : "input_text"
                    }
                  ],
                  "role" : "user",
                  "type" : "message"
                }
              ],
              "model" : "gpt-4o"
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseRequestIsEncodableWithImageInputs() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .list([
                            .text("What are in these images? Is there any difference between them?"),
                            .imageURL(URL(string: "https://upload.wikimedia.org/snip_1")!),
                            .imageURL(URL(string: "https://upload.wikimedia.org/snip_2")!),
                        ])
                    ),
                ]
            ),
            model: "gpt-4o-mini"
        )

        XCTAssertEqual(
            #"""
            {
              "input" : [
                {
                  "content" : [
                    {
                      "text" : "What are in these images? Is there any difference between them?",
                      "type" : "input_text"
                    },
                    {
                      "image_url" : "https:\/\/upload.wikimedia.org\/snip_1",
                      "type" : "input_image"
                    },
                    {
                      "image_url" : "https:\/\/upload.wikimedia.org\/snip_2",
                      "type" : "input_image"
                    }
                  ],
                  "role" : "user",
                  "type" : "message"
                }
              ],
              "model" : "gpt-4o-mini"
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }
    
    func testResponseRequestIsEncodableWithPreviousResponseId() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .text("Tell me another joke")
                    ),
                ]
            ),
            model: "gpt-4o",
            previousResponseId: "1234"
        )
        XCTAssertEqual(
                """
                {
                  "input" : [
                    {
                      "content" : "Tell me another joke",
                      "role" : "user",
                      "type" : "message"
                    }
                  ],
                  "model" : "gpt-4o",
                  "previous_response_id" : "1234"
                }
                """, try requestBody.serialize(pretty: true))
    }

    func testResponseRequestIsEncodableWithStructuredOutputs() throws {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "colors": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": [
                                "type": "string",
                                "description": "A descriptive name to give the color"
                            ],
                            "hex_code": [
                                "type": "string",
                                "description": "The hex code of the color"
                            ]
                        ],
                        "required": ["name", "hex_code"],
                        "additionalProperties": false
                    ]
                ]
            ],
            "required": ["colors"],
            "additionalProperties": false
        ]
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items([
                .message(role: .system, content: .text("You are a color palette generator")),
                .message(role: .user, content: .text("Return a peaches and cream color palette"))
            ]),
            model: "gpt-4o",
            text: .init(
                format: .jsonSchema(
                    name: "palette",
                    schema: schema,
                    description: "A list of colors that make up a color pallete",
                    strict: true
                )
            )
        )

        XCTAssertEqual(
            """
            {
              "input" : [
                {
                  "content" : "You are a color palette generator",
                  "role" : "system",
                  "type" : "message"
                },
                {
                  "content" : "Return a peaches and cream color palette",
                  "role" : "user",
                  "type" : "message"
                }
              ],
              "model" : "gpt-4o",
              "text" : {
                "format" : {
                  "description" : "A list of colors that make up a color pallete",
                  "name" : "palette",
                  "schema" : {
                    "additionalProperties" : false,
                    "properties" : {
                      "colors" : {
                        "items" : {
                          "additionalProperties" : false,
                          "properties" : {
                            "hex_code" : {
                              "description" : "The hex code of the color",
                              "type" : "string"
                            },
                            "name" : {
                              "description" : "A descriptive name to give the color",
                              "type" : "string"
                            }
                          },
                          "required" : [
                            "name",
                            "hex_code"
                          ],
                          "type" : "object"
                        },
                        "type" : "array"
                      }
                    },
                    "required" : [
                      "colors"
                    ],
                    "type" : "object"
                  },
                  "strict" : true,
                  "type" : "json_schema"
                }
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseRequestWithMinimalReasoningEffort() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .text("Explain quantum physics"),
            model: "o1-mini",
            reasoning: .init(effort: .minimal)
        )
        
        XCTAssertEqual(
            """
            {
              "input" : "Explain quantum physics",
              "model" : "o1-mini",
              "reasoning" : {
                "effort" : "minimal"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseRequestWithVerbosity() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .text("Write a short story"),
            model: "gpt-4o",
            text: .init(verbosity: .low)
        )
        
        XCTAssertEqual(
            """
            {
              "input" : "Write a short story",
              "model" : "gpt-4o",
              "text" : {
                "verbosity" : "low"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseRequestWithReasoningSummary() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .text("Explain your reasoning"),
            model: "o1",
            reasoning: .init(effort: .high, summary: .detailed)
        )
        
        XCTAssertEqual(
            """
            {
              "input" : "Explain your reasoning",
              "model" : "o1",
              "reasoning" : {
                "effort" : "high",
                "summary" : "detailed"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseRequestWithAllNewFeatures() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .text("Solve this complex problem with full detail"),
            model: "o1",
            reasoning: .init(effort: .minimal, summary: .auto),
            text: .init(verbosity: .high)
        )
        
        XCTAssertEqual(
            """
            {
              "input" : "Solve this complex problem with full detail",
              "model" : "o1",
              "reasoning" : {
                "effort" : "minimal",
                "summary" : "auto"
              },
              "text" : {
                "verbosity" : "high"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

}

