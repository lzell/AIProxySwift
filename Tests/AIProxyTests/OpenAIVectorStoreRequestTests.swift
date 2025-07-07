//
//  OpenAIVectorStoreRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 7/6/25.
//

import XCTest
@testable import AIProxy

final class OpenAIVectorStoreRequestTests: XCTestCase {

    func testCreateRequestWithAutoChunkingIsEncodable() throws {
        let requestBody = OpenAICreateVectorStoreRequestBody(
            chunkingStrategy: .auto,
            name: "vectorstore_1"
        )
        XCTAssertEqual(
            """
            {
              "chunking_strategy" : {
                "type" : "auto"
              },
              "name" : "vectorstore_1"
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testCreateRequestWithSpecificChunkingIsEncodable() throws {
        let requestBody = OpenAICreateVectorStoreRequestBody(
            chunkingStrategy: .static(chunkOverlapTokens: 300, maxChunkSizeTokens: 700),
            name: "vectorstore_1"
        )
        XCTAssertEqual(
            """
            {
              "chunking_strategy" : {
                "static" : {
                  "chunk_overlap_tokens" : 300,
                  "max_chunk_size_tokens" : 700
                },
                "type" : "static"
              },
              "name" : "vectorstore_1"
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }
}

