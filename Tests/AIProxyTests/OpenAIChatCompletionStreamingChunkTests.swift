//
//  OpenAIChatCompletionStreamingChunkTests.swift
//
//
//  Created by Lou Zell on 8/17/24.
//

import XCTest
@testable import AIProxy

final class OpenAIChatCompletionStreamingChunkTests: XCTestCase {
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
}
