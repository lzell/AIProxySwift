//
//  FalFluxSchnellResponseTests.swift
//
//
//  Created by Hunor Zoltáni on 01.03.2025.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalFluxSchnellResponseTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = """
            {
              "images": [
                {
                  "url": "https://fal.media/files/zebra/_9NDmaWO5okNq9idPY7Il.jpeg",
                  "width": 1024,
                  "height": 1024,
                  "content_type": "image/jpeg"
                }
              ],
              "timings": {
                "inference": 2.1141920797526836
              },
              "seed": 2062765390712234200,
              "has_nsfw_concepts": [
                false
              ],
              "prompt": "winter wonderland"
            }
        """
        let res = try FalFluxSchnellOutputSchema.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "https://fal.media/files/zebra/_9NDmaWO5okNq9idPY7Il.jpeg",
            res.images?.first?.url?.absoluteString
        )
    }
}
