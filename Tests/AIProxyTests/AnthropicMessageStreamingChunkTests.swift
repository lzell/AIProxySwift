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

    func testContentBlockDeltaIsDecodable() {
        let serializedChunk = #"data: {"type":"content_block_delta","index":0,"delta":{"type":"text_delta","text":"Hello! How"}}"#
        let contentBlockDelta = AnthropicContentBlockDelta.deserialize(fromLine: serializedChunk)
        switch contentBlockDelta?.delta {
        case .textDelta(let textDelta):
            XCTAssertEqual("Hello! How", textDelta.text)
        default:
            XCTFail()
        }
    }

    func testContentBlockStartIsDecodable() {
        let serializedChunk = #"data: {"type":"content_block_start","index":1,"content_block":{"type":"tool_use","id":"toolu_01T1x1fJ34qAmk2tNTrN7Up6","name":"get_weather","input":{}}}"#
        let contentBlockStart = AnthropicContentBlockStart.deserialize(fromLine: serializedChunk)
        switch contentBlockStart?.contentBlock {
        case .toolUseBlock(let toolUseBlock):
            XCTAssertEqual("get_weather", toolUseBlock.name)
            XCTAssertEqual("toolu_01T1x1fJ34qAmk2tNTrN7Up6", toolUseBlock.id)
        default:
            XCTFail()
        }
    }
}
