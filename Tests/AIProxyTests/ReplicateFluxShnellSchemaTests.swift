//
//  ReplicateFluxSchnellSchemaTests.swift
//
//
//  Created by Lou Zell on 10/21/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicateFluxSchnellSchemaTests: XCTestCase {

    func testGoFastArgumentIsEncodedInRequest() throws {
        let input = ReplicateFluxSchnellInputSchema(
            prompt: "abc",
            goFast: true
        )
        XCTAssertEqual(
            #"""
            {
              "go_fast" : true,
              "prompt" : "abc"
            }
            """#,
            try input.serialize(pretty: true)
        )
    }
}
