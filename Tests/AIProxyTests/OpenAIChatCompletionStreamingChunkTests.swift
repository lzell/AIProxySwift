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

    func testUsageIsDecodable() {
        let line = """
        data: {"id":"chatcmpl-A9MtoyoAD7JI10m0acOb3ouODNHzK","object":"chat.completion.chunk","created":1726796340,"model":"gpt-4o-mini-2024-07-18","system_fingerprint":"fp_1bb46167f9","choices":[],"usage":{"prompt_tokens":9,"completion_tokens":9,"total_tokens":18,"completion_tokens_details":{"reasoning_tokens":0}}}
        """
        let res = OpenAIChatCompletionChunk.from(line: line)
        XCTAssertEqual(9, res?.usage?.promptTokens)
        XCTAssertEqual(9, res?.usage?.completionTokens)
        XCTAssertEqual(18, res?.usage?.totalTokens)
        XCTAssertEqual(0, res?.usage?.completionTokensDetails?.reasoningTokens)
    }
}
