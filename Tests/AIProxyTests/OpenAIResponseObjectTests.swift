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
        let res = try OpenAIResponse.ResponseTextConfig.Format.deserialize(from: sampleResponse)
        XCTAssertEqual(.text, res)
    }

    func testTextConfigIsDecodable() throws {
        let sampleResponse = #"""
        {
          "format": { "type": "text" }
        }
        """#
        let res = try OpenAIResponse.ResponseTextConfig.deserialize(from: sampleResponse)
        XCTAssertEqual(.text, res.format)
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
        XCTAssertEqual(.text, res.text?.format)

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
}
