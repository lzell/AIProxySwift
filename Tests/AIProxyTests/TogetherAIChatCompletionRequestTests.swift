//
//  TogetherAIChatCompletionRequestTests.swift
//
//
//  Created by Lou Zell on 8/15/24.
//

import Foundation
import XCTest
@testable import AIProxy

final class TogetherAIChatCompletionRequestTests: XCTestCase {

    func testBasicRequestIsEncodable() throws {
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [
                TogetherAIMessage(content: "hello world", role: .user)
            ],
            model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo"
        )
        XCTAssertEqual(#"""
            {
              "messages" : [
                {
                  "content" : "hello world",
                  "role" : "user"
                }
              ],
              "model" : "meta-llama\/Meta-Llama-3.1-8B-Instruct-Turbo"
            }
            """#,
                       try requestBody.serialize(pretty: true)
        )
    }

    func testRequestWithJSONSchemaIsEncodable() throws {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "people": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": [
                                "type": "string",
                                "description": "The name of the person"
                            ],
                            "address": [
                                "type": "string",
                                "description": "The address of the person"
                            ]
                        ],
                        "required": ["name", "address"]
                    ]
                ]
            ]
        ]
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [
                TogetherAIMessage(
                    content: "You are a helpful assistant that answers in JSON",
                    role: .system
                ),
                TogetherAIMessage(
                    content: "Create three fictitious people",
                    role: .user
                )
            ],
            model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo",
            responseFormat: .json(schema: schema)
        )
        XCTAssertEqual(
            #"""
            {
              "messages" : [
                {
                  "content" : "You are a helpful assistant that answers in JSON",
                  "role" : "system"
                },
                {
                  "content" : "Create three fictitious people",
                  "role" : "user"
                }
              ],
              "model" : "meta-llama\/Meta-Llama-3.1-8B-Instruct-Turbo",
              "response_format" : {
                "schema" : {
                  "properties" : {
                    "people" : {
                      "items" : {
                        "properties" : {
                          "address" : {
                            "description" : "The address of the person",
                            "type" : "string"
                          },
                          "name" : {
                            "description" : "The name of the person",
                            "type" : "string"
                          }
                        },
                        "required" : [
                          "name",
                          "address"
                        ],
                        "type" : "object"
                      },
                      "type" : "array"
                    }
                  },
                  "type" : "object"
                },
                "type" : "json_object"
              }
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }

    func testRequestWithToolCallIsEncodable() throws {
        let function = TogetherAIFunction(
            description: "Call this when the user wants the weather",
            name: "get_weather",
            parameters: [
                "type": "object",
                "properties": [
                    "location": [
                        "type": "string",
                        "description": "The city and state, e.g. San Francisco, CA",
                    ],
                ],
                "required": ["location"],
            ]
        )
        let toolPrompt = "long prompt"
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [
                TogetherAIMessage(
                    content: toolPrompt,
                    role: .system
                ),
                TogetherAIMessage(
                    content: "What's the weather in Tokyo?",
                    role: .user
                )
            ],
            model: "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
            temperature: 0,
            tools: [
                TogetherAITool(function: function)
            ]
        )

        XCTAssertEqual(
            #"""
            {
              "messages" : [
                {
                  "content" : "long prompt",
                  "role" : "system"
                },
                {
                  "content" : "What's the weather in Tokyo?",
                  "role" : "user"
                }
              ],
              "model" : "meta-llama\/Meta-Llama-3.1-70B-Instruct-Turbo",
              "temperature" : 0,
              "tools" : [
                {
                  "function" : {
                    "description" : "Call this when the user wants the weather",
                    "name" : "get_weather",
                    "parameters" : {
                      "properties" : {
                        "location" : {
                          "description" : "The city and state, e.g. San Francisco, CA",
                          "type" : "string"
                        }
                      },
                      "required" : [
                        "location"
                      ],
                      "type" : "object"
                    }
                  },
                  "type" : "tool_type"
                }
              ]
            }
            """#
            ,
            try requestBody.serialize(pretty: true)
        )
    }

}
