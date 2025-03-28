//
//  OpenAICreateResponseRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 3/27/25.
//

import XCTest
@testable import AIProxy

final class OpenAICreateResponseRequestTests: XCTestCase {

    func testResponseRequestIsEncodableWithFileUse() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .list([
                            .file(fileID: "file-XC5txiSNGrMiP1uMb7R2HT"),
                            .text("What is the purpose of this doc?")
                        ])
                    ),
                ]
            ),
            model: "gpt-4o"
        )
        XCTAssertEqual(
            """
            {
              "input" : [
                {
                  "content" : [
                    {
                      "file_id" : "file-XC5txiSNGrMiP1uMb7R2HT",
                      "type" : "input_file"
                    },
                    {
                      "text" : "What is the purpose of this doc?",
                      "type" : "input_text"
                    }
                  ],
                  "role" : "user",
                  "type" : "message"
                }
              ],
              "model" : "gpt-4o"
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }
}

