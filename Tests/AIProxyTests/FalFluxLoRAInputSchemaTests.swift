//
//  FalFluxLoRAInputSchemaTests.swift
//
//
//  Created by Lou Zell on 10/3/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalFluxLoRAInputSchemaTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let expected = """
        {
          "guidance_scale" : 6,
          "image_size" : "landscape_16_9",
          "loras" : [
            {
              "path" : "https:\\/\\/storage.googleapis.com\\/fal-flux-lora\\/57256f3082ab4c1498c76b060ff3ffdb_pytorch_lora_weights.safetensors",
              "scale" : 1.2
            }
          ],
          "num_images" : 2,
          "num_inference_steps" : 21,
          "output_format" : "jpeg",
          "prompt" : "face",
          "seed" : 7467957
        }
        """
        let inputSchema = FalFluxLoRAInputSchema(
            prompt: "face",
            guidanceScale: 6,
            imageSize: .landscape16x9,
            loras: [
                .init(
                    path: URL(string: "https://storage.googleapis.com/fal-flux-lora/57256f3082ab4c1498c76b060ff3ffdb_pytorch_lora_weights.safetensors")!,
                    scale: 1.2
                )
            ],
            numImages: 2,
            numInferenceSteps: 21,
            outputFormat: .jpeg,
            seed: 7467957
        )
        XCTAssertEqual(
            expected,
            try inputSchema.serialize(pretty: true)
        )
    }
}
