//
//  BlackForestLabsResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 1/8/25.
//

import XCTest
import Foundation
@testable import AIProxy


final class BlackForestLabsResponseTests: XCTestCase {
    func testResultResponseBodyIsDecodable() {
        let sampleResponse = """
        {
          "id": "cc06c929-49e6-4571-9efc-50955141e287",
          "status": "Ready",
          "result": {
            "sample": "https://delivery-eu1.bfl.ai/results/bd16c3be7bb446f5aa8b008faf10e0d8/sample.jpeg?se=2025-01-09T05%3A04%3A04Z&sp=r&sv=2024-11-04&sr=b&rsct=image/jpeg&sig=hAiu66Cdzf8MSujO6%2BQgcA2s3Ki9/%2BpIp/BsQ/oyGTw%3D",
            "prompt": "a detailed, hand-drawn map of Syracuse, New York, with its iconic landmarks and neighborhoods prominently featured. The map depicts the city's grid-like layout, with the Erie Canal running through its center. The prominent features include the Clinton Square, the Onondaga Creek, and the scenic Lake Ontario shoreline. In the center of the map, a large, wooden sign is overlaid, reading \"Zell Family\" in bold, white letters, with a subtle gradient effect giving it a warm, wooden texture. The sign appears to be made of a rich, dark wood, with a slight weathered patina, as if it has been standing for years, bearing witness to the city's history.",
            "seed": 1236587245,
            "start_time": 1736398441.6336539,
            "end_time": 1736398444.3683708,
            "duration": 2.7347168922424316
          }
        }
        """
    }


}

