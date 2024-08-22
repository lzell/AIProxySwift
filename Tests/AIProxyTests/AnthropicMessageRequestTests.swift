//
//  File.swift
//
//
//  Created by Lou Zell on 7/28/24.
//

import Foundation

import XCTest
import Foundation
@testable import AIProxy


final class AnthropicMessageRequestTests: XCTestCase {

    func testRequestIsEncodable() {
        let request = AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                AnthropicInputMessage(content: [.text("hello world")], role: .user)
            ],
            model: "claude-3-5-sonnet-20240620",
            system: "You are a helpful assistant"
        )
        let data = try! request.serialize(pretty: true)
        XCTAssertEqual("""
            {
              "max_tokens" : 1024,
              "messages" : [
                {
                  "content" : [
                    {
                      "text" : "hello world",
                      "type" : "text"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "model" : "claude-3-5-sonnet-20240620",
              "system" : "You are a helpful assistant"
            }
            """,
            String(data: data, encoding: .utf8)!
        )
    }

    func testRequestWithToolUseIsEncodable() {
        let request = AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                .init(
                    content: [.text("What's the temp in San Francisco?")],
                    role: .user
                )
            ],
            model: "claude-3-5-sonnet-20240620",
            tools: [
                .init(
                    description: "Call this function when the user wants the weather",
                    inputSchema: [
                        "type": "object",
                        "properties": [
                            "location": [
                                "type": "string",
                                "description": "The city and state, e.g. San Francisco, CA"
                            ],
                            "unit": [
                              "type": "string",
                              "enum": ["celsius", "fahrenheit"],
                              "description": "The unit of temperature. Default to fahrenheit",
                              "default": "fahrenheit"
                            ]
                        ],
                        "required": ["location", "unit"]
                    ],
                    name: "get_weather"
                )
            ]
        )
        let data = try! request.serialize()
        XCTAssertEqual(
            #"{"max_tokens":1024,"messages":[{"content":[{"text":"What's the temp in San Francisco?","type":"text"}],"role":"user"}],"model":"claude-3-5-sonnet-20240620","tools":[{"description":"Call this function when the user wants the weather","input_schema":{"properties":{"location":{"description":"The city and state, e.g. San Francisco, CA","type":"string"},"unit":{"default":"fahrenheit","description":"The unit of temperature. Default to fahrenheit","enum":["celsius","fahrenheit"],"type":"string"}},"required":["location","unit"],"type":"object"},"name":"get_weather"}]}"#
            ,
            String(data: data, encoding: .utf8)!
        )
    }

    func testRequestWithImageIsEncodable() throws {
        let request = AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                AnthropicInputMessage(content: [.image(
                    mediaType: .jpeg,
                    data: "encoded-image"
                )], role: .user)
            ],
            model: "claude-3-5-sonnet-20240620"
        )
        let data = try request.serialize()
        XCTAssertEqual(
            #"{"max_tokens":1024,"messages":[{"content":[{"source":{"data":"encoded-image","media_type":"image\/jpeg","type":"base64"},"type":"image"}],"role":"user"}],"model":"claude-3-5-sonnet-20240620"}"#
            ,
            String(data: data, encoding: .utf8)!
        )
    }

    func testSystemMessageIsInitializableAsLiteral() throws {

    }
}
