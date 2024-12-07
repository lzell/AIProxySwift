//
//  EachAITriggerWorkloadResponseBodyTests.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class EachAITriggerWorkloadResponseBodyTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "success",
          "message": "Workflow triggered successfully",
          "trigger_id": "mp0tnsxinwymncyio"
        }
        """#
        let res = try EachAITriggerWorkloadResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("mp0tnsxinwymncyio", res.triggerID)
    }
}

