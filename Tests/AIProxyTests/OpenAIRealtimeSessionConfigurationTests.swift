//
//  OpenAIRealtimeSessionConfigurationTests.swift
//  AIProxy
//
//  Created by Codex on 2/15/26.
//

import XCTest
@testable import AIProxy

final class OpenAIRealtimeSessionConfigurationTests: XCTestCase {

    func testInputAudioNoiseReductionNearFieldIsEncodable() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            inputAudioNoiseReduction: .init(type: .nearField),
            speed: nil
        )

        XCTAssertEqual(
            """
            {
              "audio" : {
                "input" : {
                  "noise_reduction" : {
                    "type" : "near_field"
                  }
                }
              },
              "type" : "realtime"
            }
            """,
            try config.serialize(pretty: true)
        )
    }

    func testInputAudioNoiseReductionIsOptional() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            inputAudioFormat: .pcm16,
            speed: nil
        )

        XCTAssertEqual(
            #"""
            {
              "audio" : {
                "input" : {
                  "format" : {
                    "rate" : 24000,
                    "type" : "audio\/pcm"
                  }
                }
              },
              "type" : "realtime"
            }
            """#,
            try config.serialize(pretty: true)
        )
    }
}
