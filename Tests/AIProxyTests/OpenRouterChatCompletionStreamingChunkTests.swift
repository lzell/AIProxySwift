//
//  OpenRouterChatCompletionStreamingChunkTests.swift
//  AIProxy
//
//  Created by Lou Zell on 2/6/25.
//

import Foundation
import XCTest
@testable import AIProxy

final class OpenRouterChatCompletionStreamingChunkTests: XCTestCase {

    func testChunkWithReasoningIsDecodable() throws {
        let serializedChunk = #"data: {"id":"gen-1738800351-03h6DftoW7wSTm6uSXb7","provider":"DeepInfra","model":"deepseek/deepseek-r1","object":"chat.completion.chunk","created":1738800351,"choices":[{"index":0,"delta":{"role":"assistant","content":null,"reasoning":"ABC"},"finish_reason":null,"native_finish_reason":null,"logprobs":null}]}"#

        let body = OpenRouterChatCompletionChunk.deserialize(fromLine: serializedChunk)
        XCTAssertEqual("ABC", body!.choices.first!.delta.reasoning)
    }
}


