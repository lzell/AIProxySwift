//
//  OpenAIConversationItemTests.swift
//  AIProxy
//

import XCTest
@testable import AIProxy

final class OpenAIConversationItemTests: XCTestCase {

    func testCompactionConversationItemDecodesWithIdAndCreatedBy() throws {
        let json = #"""
        {
          "type": "compaction",
          "id": "cmp_123",
          "encrypted_content": "enc_abc123",
          "created_by": "system"
        }
        """#

        let item = try OpenAIConversationItem.deserialize(from: json)
        guard case .compaction(let compaction) = item else {
            return XCTFail("Expected .compaction")
        }
        XCTAssertEqual("cmp_123", compaction.id)
        XCTAssertEqual("enc_abc123", compaction.encryptedContent)
        XCTAssertEqual("system", compaction.createdBy)
    }

    func testCompactionConversationItemDecodesWithoutOptionalFields() throws {
        let json = #"""
        {
          "type": "compaction",
          "encrypted_content": "enc_only"
        }
        """#

        let item = try OpenAIConversationItem.deserialize(from: json)
        guard case .compaction(let compaction) = item else {
            return XCTFail("Expected .compaction")
        }
        XCTAssertNil(compaction.id)
        XCTAssertNil(compaction.createdBy)
        XCTAssertEqual("enc_only", compaction.encryptedContent)
    }
}
