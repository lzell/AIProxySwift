//
//  TogetherAIChatCompletionResponseTests.swift
//
//
//  Created by Lou Zell on 8/16/24.
//

import Foundation
import XCTest
@testable import AIProxy

final class TogetherAIChatCompletionResponseTests: XCTestCase {
    
    func testBasicChatResponseIsDecodable() throws {
        let serializedBody = #"""
        {
          "id": "8b4391667f4967b9-SJC",
          "object": "chat.completion",
          "created": 1723833785,
          "model": "meta-llama/meta-llama-3.1-8b-instruct-turbo",
          "prompt": [],
          "choices": [
            {
              "finish_reason": "eos",
              "seed": 14429055041780593000,
              "logprobs": null,
              "index": 0,
              "message": {
                "role": "assistant",
                "content": "Hello world"
              }
            }
          ],
          "usage": {
            "prompt_tokens": 12,
            "completion_tokens": 27,
            "total_tokens": 39
          }
        }
        """#
        let body = try TogetherAIChatCompletionResponseBody.deserialize(from: serializedBody)
        XCTAssertEqual("Hello world", body.choices.first!.message.content)
    }

    func testJSONChatResponseIsDecodable() throws {
        let serializedBody = #"""
        {
          "id": "8b44503df8a22522-SJC",
          "object": "chat.completion",
          "created": 1723841605,
          "model": "meta-llama/meta-llama-3.1-8b-instruct-turbo",
          "prompt": [],
          "choices": [
            {
              "logprobs": null,
              "index": 0,
              "seed": null,
              "message": {
                "role": "assistant",
                "content": "{\"people\": [{\"address\": \"100 Main St\", \"name\": \"Alice Bob\"}]}"
              }
            }
          ],
          "usage": {
            "prompt_tokens": 49,
            "total_tokens": 101,
            "completion_tokens": 52
          }
        }
        """#
        let responseBody = try TogetherAIChatCompletionResponseBody.deserialize(from: serializedBody)
        XCTAssertEqual(
            "{\"people\": [{\"address\": \"100 Main St\", \"name\": \"Alice Bob\"}]}",
            responseBody.choices.first!.message.content
        )
    }
}
