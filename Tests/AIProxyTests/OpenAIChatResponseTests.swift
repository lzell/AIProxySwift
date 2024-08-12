//
//  OpenAIChatResponseTests.swift
//
//
//  Created by Lou Zell on 8/11/24.
//

import XCTest
@testable import AIProxy

final class OpenAIChatResponseTests: XCTestCase {

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

    func testChatCompletionResponseChunkIsDecodable() {
        let line = """
        data: {"id":"chatcmpl-9jAXUtD5xAKjjgo3XBZEawyoRdUGk","object":"chat.completion.chunk","created":1720552300,"model":"gpt-3.5-turbo-0125","system_fingerprint":null,"choices":[{"index":0,"delta":{"content":"FINDME"},"logprobs":null,"finish_reason":null}],"usage":null}
        """
        let res = OpenAIChatCompletionChunk.from(line: line)
        XCTAssertEqual(
            "FINDME",
            res?.choices.first?.delta.content
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
}
