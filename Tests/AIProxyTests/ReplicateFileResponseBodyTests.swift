//
//  ReplicateFileResponseBodyTests.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicateFileResponseBodyTests: XCTestCase {

    func testUploadFileResponseIsDecodable() throws {
        let responseBody = """
        {
          "id": "MzQ4YjZmYWQtZWMzNS00ZWI2LTk2MGEtZDQ2YTJkYWU4YzAx",
          "name": "training.zip",
          "content_type": "application/zip",
          "size": 358732,
          "etag": "c6f4001d286dc33f28763042bacb05a8",
          "checksums": {
            "sha256": "6b6fa3db39421c7ee4ae6d0099c8351f3d53599f3b2e41993c8a7c91cd502a87",
            "md5": "c6f4001d286dc33f28763042bacb05a8"
          },
          "metadata": {},
          "created_at": "2024-09-10T00:31:35.115Z",
          "expires_at": "2024-09-11T00:31:35.115Z",
          "urls": {
            "get": "https://api.replicate.com/v1/files/MzQ4YjZmYWQtZWMzNS00ZWI2LTk2MGEtZDQ2YTJkYWU4YzAx"
          }
        }
        """
        let res = try ReplicateFileUploadResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual("2024-09-11T00:31:35.115Z", res.expiresAt)
        XCTAssertEqual(
            "https://api.replicate.com/v1/files/MzQ4YjZmYWQtZWMzNS00ZWI2LTk2MGEtZDQ2YTJkYWU4YzAx",
            res.urls.get.absoluteString
        )
        XCTAssertNotNil(res.expiresAt)
    }
}
