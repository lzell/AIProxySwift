//
//  WaveSpeedAIResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

import Foundation
import XCTest
@testable import AIProxy

final class WaveSpeedAIResponseTests: XCTestCase {

    func testCreatePredictionResponseIsDecodable() throws {
        let serializedBody = #"""
        {
          "code": 200,
          "message": "success",
          "data": {
            "id": "6488c2754f6f4dfea924382fa14d11bd",
            "model": "alibaba/wan-2.5/text-to-image",
            "outputs": [],
            "urls": {
              "get": "https://api.wavespeed.ai/api/v3/predictions/6488c2754f6f4dfea924382fa14d11bd/result"
            },
            "has_nsfw_contents": [],
            "status": "created",
            "created_at": "2025-09-29T23:09:43.027Z",
            "error": "",
            "executionTime": 0,
            "timings": {
              "inference": 0
            }
          }
        }
        """#
        let body = try WaveSpeedAICreatePredictionResponseBody.deserialize(from: serializedBody)
        XCTAssertEqual("6488c2754f6f4dfea924382fa14d11bd", body.data?.id)
    }
}
