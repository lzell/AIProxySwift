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
              "input_audio_noise_reduction" : {
                "type" : "near_field"
              }
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
            """
            {
              "input_audio_format" : "pcm16"
            }
            """,
            try config.serialize(pretty: true)
        )
    }
}
