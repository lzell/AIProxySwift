//
//  GeminiFileUploadResponseBodyTests.swift
//
//
//  Created by Lou Zell on 10/24/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class GeminiFileUploadResponseBodyTests: XCTestCase {

    func testUploadFileResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
            "file": {
                "createTime": "2024-10-23T23:57:56.546446Z",
                "expirationTime": "2024-10-25T23:57:56.477127362Z",
                "mimeType": "video/mp4",
                "name": "files/mry3nxa31le3",
                "sha256Hash": "MjQzZjY4MWFmMDllNDhiYjJkNGNlZWUxYzg5ZGM3MWRmNzcyMjgwODUyMDFlMjUxM2JjZWQ0OGI1NDdlZDg4OQ==",
                "sizeBytes": "106677",
                "state": "PROCESSING",
                "updateTime": "2024-10-23T23:57:56.546446Z",
                "uri": "https://generativelanguage.googleapis.com/v1beta/files/mry3nxa31le3"
            }
        }
        """#
        let res = try GeminiFileUploadResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(.processing, res.file.state)
    }
}

