//
//  TogetherAIChatCompletionStreamingChunkTests.swift
//
//
//  Created by Lou Zell on 8/16/24.
//

import Foundation
import XCTest
@testable import AIProxy

final class TogetherAIChatCompletionStreamingChunkTests: XCTestCase {

    func testChunkWithoutUsageIsDecodable() throws {
        let serializedChunk = #"data: {"id":"8b43a5cfadf99e5c-SJC","object":"chat.completion.chunk","created":1723834621,"choices":[{"index":0,"text":"ABC","logprobs":null,"finish_reason":null,"seed":null,"delta":{"token_id":30,"role":"assistant","content":"ABC","tool_calls":null}}],"model":"meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo","usage":null}"#

        let body = try TogetherAIChatCompletionStreamingChunk.deserialize(fromLine: serializedChunk)
        XCTAssertEqual("ABC", body!.choices.first!.delta.content)
    }

    func testChunkWithUsageIsDecodable() throws {
        let serializedChunk = #"data: {"id":"8b43a5cfadf99e5c-SJC","object":"chat.completion.chunk","created":1723834621,"choices":[{"index":0,"text":"ABC","logprobs":null,"finish_reason":"eos","seed":2039908639335532000,"delta":{"token_id":128009,"role":"assistant","content":"ABC","tool_calls":null}}],"model":"meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo","usage":{"prompt_tokens":12,"completion_tokens":27,"total_tokens":39}}"#
        let body = try TogetherAIChatCompletionStreamingChunk.deserialize(fromLine: serializedChunk)
        XCTAssertEqual("ABC", body!.choices.first!.delta.content)
        XCTAssertEqual(12, body!.usage!.promptTokens)
    }
}
