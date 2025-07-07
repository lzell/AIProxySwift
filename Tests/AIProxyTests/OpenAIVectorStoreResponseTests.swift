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

    func testCreateFileResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "id": "file-R4bFXPpUPizrLf6hqsvxps",
          "object": "vector_store.file",
          "usage_bytes": 0,
          "created_at": 1751898270,
          "vector_store_id": "vs_686",
          "status": "in_progress",
          "last_error": null,
          "chunking_strategy": {
            "type": "static",
            "static": {
              "max_chunk_size_tokens": 800,
              "chunk_overlap_tokens": 400
            }
          },
          "attributes": {}
        }
        """
        let res = try OpenAIVectorStoreFile.deserialize(from: sampleResponse)
        XCTAssertEqual(.inProgress, res.status)
        XCTAssertEqual("vs_686", res.vectorStoreId)
        guard case .static(let chunkOverlapTokens, let maxChunkSizeTokens) = res.chunkingStrategy else {
            return XCTFail("Expected a static chunking strategy")
        }
        XCTAssertEqual(400, chunkOverlapTokens)
        XCTAssertEqual(800, maxChunkSizeTokens)
    }
}
