//
//  OpenAIVectorStoreResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 7/6/25.
//

import XCTest
@testable import AIProxy

final class OpenAIVectorStoreResponseTests: XCTestCase {

    func testCreateResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "id": "vs_686",
          "object": "vector_store",
          "created_at": 1751830140,
          "name": "deleteme_2",
          "usage_bytes": 0,
          "file_counts": {
            "in_progress": 0,
            "completed": 0,
            "failed": 0,
            "cancelled": 0,
            "total": 0
          },
          "status": "completed",
          "expires_after": null,
          "expires_at": null,
          "last_active_at": 1751830140,
          "metadata": {}
        }
        """
        let res = try OpenAIVectorStore.deserialize(from: sampleResponse)
        XCTAssertEqual(.completed, res.status)
        XCTAssertEqual(0, res.fileCounts?.inProgress)
        XCTAssertEqual("vs_686", res.id)
    }
}
