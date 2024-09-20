//
//  OpenAIChatCompletionResponseTests.swift
//
//
//  Created by Lou Zell on 8/11/24.
//

import XCTest
@testable import AIProxy

final class OpenAIChatCompletionResponseTests: XCTestCase {

    func testChatCompletionResponseBodyIsDecodable() throws {
        let sampleResponse = """
        {
          "id": "chatcmpl-A9Mr6SqhWJJvxwlJ5ucAvyjJ6OSVY",
          "object": "chat.completion",
          "created": 1726796172,
          "model": "o1-mini-2024-09-12",
          "choices": [
            {
              "index": 0,
              "message": {
                "role": "assistant",
                "content": "Hello! How can I assist you today?",
                "refusal": null
              },
              "finish_reason": "stop"
            }
          ],
          "usage": {
            "prompt_tokens": 10,
            "completion_tokens": 661,
            "total_tokens": 671,
            "completion_tokens_details": {
              "reasoning_tokens": 640
            }
          },
          "system_fingerprint": "fp_9620a98a6c"
        }
        """

        let res = try OpenAIChatCompletionResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("o1-mini-2024-09-12", res.model)
        XCTAssertEqual(
            "Hello! How can I assist you today?",
            res.choices.first?.message.content
        )
        XCTAssertEqual(10, res.usage?.promptTokens)
        XCTAssertEqual(661, res.usage?.completionTokens)
        XCTAssertEqual(671, res.usage?.totalTokens)
        XCTAssertEqual(640, res.usage?.completionTokensDetails?.reasoningTokens)
    }

    func testCreateImageResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "created": 1721071915,
          "data": [
            {
              "revised_prompt": "An outdoor winter scene.",
              "url": "https://api.example.com/image.png"
            }
          ]
        }
        """

        let res = try OpenAICreateImageResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "An outdoor winter scene.",
            res.data.first?.revisedPrompt
        )
        XCTAssertEqual(
            URL(string: "https://api.example.com/image.png"),
            res.data.first?.url
        )
    }

    // This tests the response for function calling in this announcement:
    // https://openai.com/index/introducing-structured-outputs-in-the-api/
    func testResponseWithToolUseAndStructuredOutputsIsDecodable() throws {
        let sampleResponse = #"""
        {
          "id": "chatcmpl-9yhYJX5jQtBCHOiPkAxvGmHFPEZcS",
          "object": "chat.completion",
          "created": 1724254123,
          "model": "gpt-4o-2024-08-06",
          "choices": [
            {
              "index": 0,
              "message": {
                "role": "assistant",
                "content": null,
                "tool_calls": [
                  {
                    "id": "call_DJl0fscEzKiVZXXrW56Azbq9",
                    "type": "function",
                    "function": {
                      "name": "query",
                      "arguments": "{\"columns\":[\"id\",\"status\",\"expected_delivery_date\",\"delivered_at\"],\"order_by\":\"asc\",\"table_name\":\"orders\",\"conditions\":[{\"value\":\"2023-05-01\",\"operator\":\">=\",\"column\":\"ordered_at\"},{\"value\":\"2023-05-31\",\"operator\":\"<=\",\"column\":\"ordered_at\"},{\"value\":\"fulfilled\",\"operator\":\"=\",\"column\":\"status\"},{\"value\":{\"column_name\":\"expected_delivery_date\"},\"operator\":\"<\",\"column\":\"delivered_at\"}]}"
                    }
                  }
                ],
                "refusal": null
              },
              "logprobs": null,
              "finish_reason": "tool_calls"
            }
          ],
          "usage": {
            "prompt_tokens": 185,
            "completion_tokens": 108,
            "total_tokens": 293
          },
          "system_fingerprint": "fp_2a322c9ffc"
        }
        """#
        let res = try OpenAIChatCompletionResponseBody.deserialize(from: sampleResponse)
        let functionToCall = res.choices.first!.message.toolCalls!.first!.function
        let arguments = functionToCall.arguments!
        XCTAssertEqual(
            "orders",
            arguments["table_name"] as? String
        )
        XCTAssertEqual(
            "asc",
            arguments["order_by"] as? String
        )
        XCTAssertEqual(
            4,
            (arguments["conditions"] as? [Any])?.count
        )
    }
}
