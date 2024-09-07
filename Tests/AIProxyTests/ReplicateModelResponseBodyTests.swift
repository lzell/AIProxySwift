//
//  ReplicateModelResponseBodyTests.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicateModelResponseBodyTests: XCTestCase {

    func testCreateModelResponseIsDecodable() throws {
        let responseBody = """
        {
          "cover_image_url": null,
          "created_at": "2024-09-08T02:22:30.297358Z",
          "default_example": null,
          "description": "My first model",
          "github_url": null,
          "latest_version": null,
          "license_url": null,
          "name": "my-model",
          "owner": "lzell",
          "paper_url": null,
          "run_count": 0,
          "url": "https://replicate.com/lzell/my-model",
          "visibility": "private"
        }
        """
        let res = try ReplicateModelResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual(.private, res.visibility)
        XCTAssertEqual(
            "https://replicate.com/lzell/my-model",
            res.url?.absoluteString
        )
    }
}
