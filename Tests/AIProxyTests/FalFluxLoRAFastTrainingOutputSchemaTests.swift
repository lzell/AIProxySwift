//
//  FalLoraTrainingResponseTests.swift
//
//
//  Created by Lou Zell on 10/3/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalFluxLoRAFastTrainingOutputSchemaTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "diffusers_lora_file": {
            "url": "https://storage.googleapis.com/fal-flux-lora/57256f3082ab4c1498c76b060ff3ffdb_pytorch_lora_weights.safetensors",
            "content_type": "application/octet-stream",
            "file_name": "pytorch_lora_weights.safetensors",
            "file_size": 89745224
          },
          "config_file": {
            "url": "https://storage.googleapis.com/fal-flux-lora/3b950c5c7bfc42929ba8e383363864ee_config.json",
            "content_type": "application/octet-stream",
            "file_name": "config.json",
            "file_size": 1268
          }
        }
        """
        let res = try FalFluxLoRAFastTrainingOutputSchema.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "https://storage.googleapis.com/fal-flux-lora/57256f3082ab4c1498c76b060ff3ffdb_pytorch_lora_weights.safetensors",
            res.diffusersLoraFile?.url?.absoluteString
        )
    }
}
