//
//  EachAITriggerWorkflowResponseBodyTests.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class EachAITriggerWorkflowResponseBodyTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "success",
          "message": "Workflow triggered successfully",
          "trigger_id": "mp0tnsxinwymncyio"
        }
        """#
        let res = try EachAITriggerWorkflowResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("mp0tnsxinwymncyio", res.triggerID)
        XCTAssertEqual("success", res.status)
        XCTAssertEqual("Workflow triggered successfully", res.message)
    }
}

