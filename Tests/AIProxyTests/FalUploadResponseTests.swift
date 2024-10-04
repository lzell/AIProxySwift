//
//  FalUploadResponseTest.swift
//
//
//  Created by Lou Zell on 10/3/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalUploadResponseTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "file_url": "https://storage.googleapis.com/isolate-dev-hot-rooster-A",
          "upload_url": "https://storage.googleapis.com/isolate-dev-hot-rooster-B"
        }
        """
        let res = try FalInitiateUploadResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "https://storage.googleapis.com/isolate-dev-hot-rooster-A",
            res.fileURL.absoluteString
        )
        XCTAssertEqual(
            "https://storage.googleapis.com/isolate-dev-hot-rooster-B",
            res.uploadURL.absoluteString
        )
    }
}
