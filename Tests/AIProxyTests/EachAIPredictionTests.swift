//
//  EachAIPredictionTests.swift
//  AIProxy
//
//  Created by Lou Zell on 7/31/25.
//

import XCTest
import Foundation
@testable import AIProxy

final class EachAIPredictionTests: XCTestCase {

    func testCreatePredictionRequestIsEncodable() throws {
        let input: EachAIImagenInput = EachAIImagenInput(prompt: "skier")
        let requestBody = EachAICreatePredictionRequestBody(
            input: input,
            model: "imagen-4-fast",
            version: "0.0.1"
        )
        XCTAssertEqual(
            #"""
            {
              "input" : {
                "prompt" : "skier"
              },
              "model" : "imagen-4-fast",
              "version" : "0.0.1"
            }
            """#
            ,
            try requestBody.serialize(pretty: true)
        )
    }

    func testCreatePredictionResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "success",
          "message": "Prediction created successfully",
          "predictionID": "abc"
        }
        """#
        let res = try EachAICreatePredictionResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("abc", res.predictionID)
        XCTAssertEqual("success", res.status)
        XCTAssertEqual("Prediction created successfully", res.message)
    }

    func testGetPredictionResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "id": "abc",
          "input": {
            "prompt": "skier"
          },
          "logs": null,
          "status": "starting",
          "output": "",
          "metrics": {
            "predict_time": 123,
            "cost": 0
          },
          "urls": {
            "cancel": "https://api.eachlabs.ai/v1/prediction/abc/cancel",
            "get": "https://api.eachlabs.ai/v1/prediction/abc"
          }
        }
        """#
        let res = try EachAIPrediction.deserialize(from: sampleResponse)
        XCTAssertEqual("abc", res.id)
        XCTAssertEqual("skier", res.input?.prompt)
        XCTAssertEqual(123, res.metrics?.predictTime)
        XCTAssertEqual("https://api.eachlabs.ai/v1/prediction/abc", res.urls?.get)
    }
}

