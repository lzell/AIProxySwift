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

    func testPredictionRequestIsEncodable() throws {
        let input: EachAIImagenInput = EachAIImagenInput(prompt: "skier")
        let requestBody = EachAIPredictionRequestBody(
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

    func testPredictionResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "success",
          "message": "Prediction created successfully",
          "predictionID": "abc"
        }
        """#
        let res = try EachAIPredictionResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("abc", res.predictionID)
        XCTAssertEqual("success", res.status)
        XCTAssertEqual("Prediction created successfully", res.message)
    }
}

