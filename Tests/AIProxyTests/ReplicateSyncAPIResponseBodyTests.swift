//
//  ReplicateSyncAPIResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 1/29/25.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicateSyncAPIResponseBodyTests: XCTestCase {
    func testReplicateFluxProResponseIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "kwvnpcac8drj00cmpp48fvvgbr",
          "model": "philz1337x/clarity-upscaler",
          "version": "dfad41707589d68ecdccd1dfa600d55a208f9310748e44bfe35b4a6291453d5e",
          "input": {
            "creativity": 0.35,
            "downscaling_resolution": 768,
            "dynamic": 6,
            "handfix": "disabled",
            "image": "data:image/jpeg;base64,...",
            "negative_prompt": "(worst quality, low quality, normal quality:2) JuggernautNegative-neg",
            "num_inference_steps": 18,
            "output_format": "png",
            "prompt": "masterpiece, best quality, highres, <lora:more_details:0.5> <lora:SDXLrender_v2.0:1>",
            "resemblance": 0.6,
            "scale_factor": 122.5,
            "scheduler": "DPM++ 3M SDE Karras",
            "sd_model": "juggernaut_reborn.safetensors [338b85bc4f]",
            "seed": 1337,
            "tiling_height": 144,
            "tiling_width": 112
          },
          "logs": "",
          "output": null,
          "data_removed": false,
          "error": null,
          "status": "starting",
          "created_at": "2025-01-30T04:46:36.099Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/kwvnpcac8drj00cmpp48fvvgbr/cancel",
            "get": "https://api.replicate.com/v1/predictions/kwvnpcac8drj00cmpp48fvvgbr",
            "stream": "https://stream.replicate.com/v1/files/yswh-3iil5a2sisvp4yn2iahzihmbud3xzb6zaphn6265qbekothccx2a"
          }
        }
        """#
        let response = try ReplicateSynchronousResponseBody<[String]>.deserialize(from: responseBody)
        XCTAssertNil(response.output)
        XCTAssertEqual(
            "https://api.replicate.com/v1/predictions/kwvnpcac8drj00cmpp48fvvgbr",
            response.predictionResultURL?.absoluteString
        )
    }
}


