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
          "id": "chatcmpl-9Z8TAXo6bxOBAFgLghnhv8vzjmh5j",
          "object": "chat.completion",
          "created": 1718161064,
          "model": "gpt-4o-2024-05-13",
          "choices": [
            {
              "index": 0,
              "message": {
                "role": "assistant",
                "content": "The image is a blank gray square"
              },
              "logprobs": null,
              "finish_reason": "stop"
            }
          ],
          "usage": {
            "prompt_tokens": 276,
            "completion_tokens": 29,
            "total_tokens": 305
          },
          "system_fingerprint": "fp_aa87380ac5"
        }
        """

        let decoder = JSONDecoder()
        let res = try decoder.decode(
            OpenAIChatCompletionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        XCTAssertEqual("gpt-4o-2024-05-13", res.model)
        XCTAssertEqual(
            "The image is a blank gray square",
            res.choices.first?.message.content
        )
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

        let decoder = JSONDecoder()
        let res = try decoder.decode(
            OpenAICreateImageResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
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
        let decoder = JSONDecoder()
        let res = try decoder.decode(
            OpenAIChatCompletionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
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
