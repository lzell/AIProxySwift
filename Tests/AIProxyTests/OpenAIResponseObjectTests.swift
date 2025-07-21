//
//  OpenAIResponseObjectTests.swift
//  AIProxy
//
//  Created by Lou Zell on 3/14/25.
//

import XCTest
@testable import AIProxy

final class OpenAIResponseObjectTests: XCTestCase {

    func testTextFormatIsDecodable() throws {
        let sampleResponse = #"""
        { "type": "text" }
        """#
        let res = try OpenAIResponse.TextConfiguration.Format.deserialize(from: sampleResponse)
        guard case .text = res else {
            return XCTFail()
        }
    }

    func testResponseTextIsDecodable() throws {
        let sampleResponse = #"""
        {
          "format": { "type": "text" }
        }
        """#
        let res = try OpenAIResponse.TextConfiguration.deserialize(from: sampleResponse)
        guard case .text = res.format else {
            return XCTFail()
        }
    }

    func testCreateResponseResponseBodyIsDecodable() throws {

        let sampleResponse = #"""
        {
          "id": "resp_67d32c01d5b08192bf6055a7e46dc8c909c5759fa6795b7d",
          "object": "response",
          "created_at": 1741892609,
          "status": "completed",
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "model": "gpt-4o-2024-08-06",
          "output": [
            {
              "type": "message",
              "id": "msg_67d32c0230548192bf2ab9bbe758f93a09c5759fa6795b7d",
              "status": "completed",
              "role": "assistant",
              "content": [
                {
                  "type": "output_text",
                  "text": "Hello! How can I assist you today?",
                  "annotations": []
                }
              ]
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "reasoning": {
            "effort": null,
            "generate_summary": null
          },
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "text"
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": {
            "input_tokens": 26,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 10,
            "output_tokens_details": {
              "reasoning_tokens": 0
            },
            "total_tokens": 36
          },
          "user": null,
          "metadata": {}
        }
        """#
        let res = try OpenAIResponse.deserialize(from: sampleResponse)
        // Check top-level properties.
        XCTAssertEqual("resp_67d32c01d5b08192bf6055a7e46dc8c909c5759fa6795b7d", res.id)
        XCTAssertEqual(1741892609, res.createdAt)
        XCTAssertEqual(.completed, res.status)
        XCTAssertNil(res.error)
        XCTAssertNil(res.incompleteDetails)
        XCTAssertNil(res.instructions)
        XCTAssertNil(res.maxOutputTokens)
        XCTAssertEqual("gpt-4o-2024-08-06", res.model)

        guard let firstOutput = res.output.first,
              case .message(let messageContent) = firstOutput,
              let firstContent = messageContent.content.first,
              case .outputText(let responseOutputText) = firstContent else {
            XCTFail("Expected first output item to be a .message with .outputText content")
            return
        }

        XCTAssertEqual("Hello! How can I assist you today?", responseOutputText.text)
        XCTAssertEqual("Hello! How can I assist you today?", res.outputText)
        XCTAssertEqual(true, res.parallelToolCalls)
        XCTAssertNil(res.previousResponseId)
        XCTAssertNil(res.reasoning?.effort)
        XCTAssertNil(res.reasoning?.generateSummary)
        XCTAssertEqual(1.0, res.temperature)
        guard case .text = res.text?.format else {
            return XCTFail()
        }

//        if case .option(let toolOption) = res.toolChoice {
//            XCTAssertEqual(.auto, toolOption)
//        } else {
//            XCTFail("Expected toolChoice to be an option with value 'auto'")
//        }
//
//        XCTAssertEqual(0, res.tools?.count)
        XCTAssertEqual(1.0, res.topP)
        XCTAssertEqual("disabled", res.truncation)
        XCTAssertEqual(26, res.usage?.inputTokens)
        XCTAssertEqual(10, res.usage?.outputTokens)
        XCTAssertEqual(0, res.usage?.outputTokensDetails?.reasoningTokens)
        XCTAssertEqual(36, res.usage?.totalTokens)
        XCTAssertNil(res.user)
        XCTAssertEqual(true, res.metadata?.isEmpty)
    }


    func testJSONModeResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "id": "resp_687e452b61d0819baf8a1bd210ebc8c40215ea063ccfb679",
          "object": "response",
          "created_at": 1753105707,
          "status": "completed",
          "background": false,
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "max_tool_calls": null,
          "model": "gpt-4o-2024-08-06",
          "output": [
            {
              "id": "msg_687e452bb2bc819bbb7f330a29ee10d50215ea063ccfb679",
              "type": "message",
              "status": "completed",
              "content": [
                {
                  "type": "output_text",
                  "annotations": [],
                  "logprobs": [],
                  "text": "{\n  \"names\": [\"Alice\", \"Bob\"]\n}"
                }
              ],
              "role": "assistant"
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "prompt_cache_key": null,
          "reasoning": {
            "effort": null,
            "summary": null
          },
          "safety_identifier": null,
          "service_tier": "default",
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "json_object"
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_logprobs": 0,
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": {
            "input_tokens": 24,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 13,
            "output_tokens_details": {
              "reasoning_tokens": 0
            },
            "total_tokens": 37
          },
          "user": null,
          "metadata": {}
        }
        """#
        let res = try OpenAIResponse.deserialize(from: sampleResponse)
    }

    func testStructuredOutputsResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "id": "resp_687e5a064e24819aa64214483e6838e2008e7175c867dce4",
          "object": "response",
          "created_at": 1753111046,
          "status": "completed",
          "background": false,
          "error": null,
          "incomplete_details": null,
          "instructions": null,
          "max_output_tokens": null,
          "max_tool_calls": null,
          "model": "gpt-4o-2024-08-06",
          "output": [
            {
              "id": "msg_687e5a07008c819a97b7939a2f5c18f9008e7175c867dce4",
              "type": "message",
              "status": "completed",
              "content": [
                {
                  "type": "output_text",
                  "annotations": [],
                  "logprobs": [],
                  "text": "{\"colors\":[{\"hex_code\":\"#FFDAB9\",\"name\":\"Peach Puff\"},{\"hex_code\":\"#FFE5B4\",\"name\":\"Peaches\"},{\"hex_code\":\"#FFF5EE\",\"name\":\"Seashell\"},{\"hex_code\":\"#FFF0E1\",\"name\":\"Papaya Whip\"},{\"hex_code\":\"#FFF2E2\",\"name\":\"Cream Blush\"}]}"
                }
              ],
              "role": "assistant"
            }
          ],
          "parallel_tool_calls": true,
          "previous_response_id": null,
          "prompt_cache_key": null,
          "reasoning": {
            "effort": null,
            "summary": null
          },
          "safety_identifier": null,
          "service_tier": "default",
          "store": true,
          "temperature": 1.0,
          "text": {
            "format": {
              "type": "json_schema",
              "description": "A list of colors that make up a color pallete",
              "name": "palette",
              "schema": {
                "additionalProperties": false,
                "properties": {
                  "colors": {
                    "items": {
                      "additionalProperties": false,
                      "properties": {
                        "hex_code": {
                          "description": "The hex code of the color",
                          "type": "string"
                        },
                        "name": {
                          "description": "A descriptive name to give the color",
                          "type": "string"
                        }
                      },
                      "required": [
                        "name",
                        "hex_code"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  }
                },
                "required": [
                  "colors"
                ],
                "type": "object"
              },
              "strict": true
            }
          },
          "tool_choice": "auto",
          "tools": [],
          "top_logprobs": 0,
          "top_p": 1.0,
          "truncation": "disabled",
          "usage": {
            "input_tokens": 102,
            "input_tokens_details": {
              "cached_tokens": 0
            },
            "output_tokens": 79,
            "output_tokens_details": {
              "reasoning_tokens": 0
            },
            "total_tokens": 181
          },
          "user": null,
          "metadata": {}
        }
        """#
        let res = try OpenAIResponse.deserialize(from: sampleResponse)
        guard case .jsonSchema(let name, let schema, let description, let strict) = res.text?.format else {
            return XCTFail()
        }
        XCTAssertEqual("palette", name)
        XCTAssertEqual(["colors"], schema.untypedDictionary["required"] as? [String])
        XCTAssertEqual("A list of colors that make up a color pallete", description)
        XCTAssert(strict == true)
    }
}
