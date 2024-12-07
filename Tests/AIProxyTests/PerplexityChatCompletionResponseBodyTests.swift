//
//  PerplexityChatCompletionResponseBodyTests.swift
//
//
//  Created by Lou Zell on 11/6/24.
//

import Foundation


import XCTest
import Foundation
@testable import AIProxy

final class PerplexityChatCompletionResponseBodyTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "167584e2-3a26-4f17-be20-2c844d40d85a",
          "model": "llama-3.1-sonar-small-128k-online",
          "created": 1730918154,
          "usage": {
            "prompt_tokens": 2,
            "completion_tokens": 360,
            "total_tokens": 362
          },
          "object": "chat.completion",
          "choices": [
            {
              "index": 0,
              "finish_reason": "stop",
              "message": {
                "role": "assistant",
                "content": "Hello world."
              },
              "delta": {
                "role": "assistant",
                "content": ""
              }
            }
          ]
        }
        """#
        let res = try PerplexityChatCompletionResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual("Hello world.", res.choices.first?.message?.content)
        XCTAssertEqual(.assistant, res.choices.first?.message?.role)
    }
}
