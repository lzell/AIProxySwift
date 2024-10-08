//
//  AnthropicMessageStreamingChunkTests.swift
//
//
//  Created by Lou Zell on 10/7/24.
//

import XCTest
import Foundation
@testable import AIProxy


final class AnthropicMessageStreamingChunkTests: XCTestCase {

    func testDeltaBlockStartIsDecodable() {
        let serializedChunk = #"data: {"type":"content_block_delta","index":0,"delta":{"type":"text_delta","text":"Hello! How"}   }"#
        let deltaBlock = AnthropicMessageStreamingDeltaBlock.from(line: serializedChunk)
        switch deltaBlock?.delta {
        case .text(let txt):
            XCTAssertEqual("Hello! How", txt)
        default:
            XCTFail()
        }
    }

    func testContentBlockStartIsDecodable() {
        let serializedChunk = #"data: {"type":"content_block_start","index":1,"content_block":{"type":"tool_use","id":"toolu_01T1x1fJ34qAmk2tNTrN7Up6","name":"get_weather","input":{}}}"#
        let contentBlockStart = AnthropicMessageStreamingContentBlockStart.from(line: serializedChunk)
        switch contentBlockStart?.contentBlock {
        case .toolUse(name: let name):
            XCTAssertEqual("get_weather", name)
        default:
            XCTFail()
        }
    }
}

