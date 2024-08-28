//
//  ReplicatePredictionRequestBodyTests.swift
//
//
//  Created by Lou Zell on 8/27/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicatePredictionRequestBodyTests: XCTestCase {

    func testBasicSDXLPredictionRequestIsEncodable() throws {
        let input = ReplicateSDXLInputSchema(
            prompt: "Monument valley, Utah"
        )
        let requestBody = ReplicatePredictionRequestBody(
            input: input,
            version: "abc"
        )
        let data = try requestBody.serialize(pretty: true)
        XCTAssertEqual(#"""
            {
              "input" : {
                "prompt" : "Monument valley, Utah"
              },
              "version" : "abc"
            }
            """#,
            String(data: data, encoding: .utf8)
        )
    }

    func testFullSDXLPredictionRequestIsEncodable() throws {
        let input = ReplicateSDXLInputSchema(
            prompt: "Monument valley, Utah",
            applyWatermark: true,
            disableSafetyChecker: true,
            guidanceScale: 0.5,
            height: 512,
            highNoiseFrac: 0.5,
            image: URL(string: "https://example.com/image")!,
            loraScale: 0.5,
            mask: URL(string: "https://example.com/mask")!,
            negativePrompt: "low quality",
            numInferenceSteps: 50,
            numOutputs: 2,
            promptStrength: 0.5,
            refine: .baseImageRefiner,
            refineSteps: 50,
            scheduler: .kEuler,
            seed: 123,
            width: 512
        )
        let requestBody = ReplicatePredictionRequestBody(
            input: input,
            version: "abc"
        )
        let data = try requestBody.serialize(pretty: true)
        XCTAssertEqual(#"""
            {
              "input" : {
                "apply_watermark" : true,
                "disable_safety_checker" : true,
                "guidance_scale" : 0.5,
                "height" : 512,
                "high_noise_frac" : 0.5,
                "image" : "https:\/\/example.com\/image",
                "lora_scale" : 0.5,
                "mask" : "https:\/\/example.com\/mask",
                "negative_prompt" : "low quality",
                "num_inference_steps" : 50,
                "num_outputs" : 2,
                "prompt" : "Monument valley, Utah",
                "prompt_strength" : 0.5,
                "refine" : "base_image_refiner",
                "refine_steps" : 50,
                "scheduler" : "K_EULER",
                "seed" : 123,
                "width" : 512
              },
              "version" : "abc"
            }
            """#,
            String(data: data, encoding: .utf8)
        )
    }

}

