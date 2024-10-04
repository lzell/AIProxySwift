//
//  FalFluxLoRAOutputSchemaTests.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalFluxLoRAOutputSchemaTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "images": [
            {
              "url": "https://fal.media/files/zebra/q9r5uYfobNHrVAa_4GGor_e9377bbec594486784d3cf306fd19a85.jpg",
              "width": 1024,
              "height": 576,
              "content_type": "image/jpeg"
            },
            {
              "url": "https://fal.media/files/panda/VMV6roybQeHhUvhvgVaPF_686e75aef65443d186f25f25d87a48cb.jpg",
              "width": 1024,
              "height": 576,
              "content_type": "image/jpeg"
            }
          ],
          "timings": {
            "inference": 4.393133059842512
          },
          "seed": 7467957,
          "has_nsfw_concepts": [
            false,
            false
          ],
          "prompt": "face"
        }
        """#
        let res = try FalFluxLoRAOutputSchema.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "https://fal.media/files/zebra/q9r5uYfobNHrVAa_4GGor_e9377bbec594486784d3cf306fd19a85.jpg",
            res.images?.first?.url?.absoluteString
        )
    }
}
