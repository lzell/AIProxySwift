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

    func testResponseRequestIsEncodableWithImageInputs() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .list([
                            .text("What are in these images? Is there any difference between them?"),
                            .imageURL(URL(string: "https://upload.wikimedia.org/snip_1")!),
                            .imageURL(URL(string: "https://upload.wikimedia.org/snip_2")!),
                        ])
                    ),
                ]
            ),
            model: "gpt-4o-mini"
        )

        XCTAssertEqual(
            #"""
            {
              "input" : [
                {
                  "content" : [
                    {
                      "text" : "What are in these images? Is there any difference between them?",
                      "type" : "input_text"
                    },
                    {
                      "image_url" : "https:\/\/upload.wikimedia.org\/snip_1",
                      "type" : "input_image"
                    },
                    {
                      "image_url" : "https:\/\/upload.wikimedia.org\/snip_2",
                      "type" : "input_image"
                    }
                  ],
                  "role" : "user",
                  "type" : "message"
                }
              ],
              "model" : "gpt-4o-mini"
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }
    
    func testResponseRequestIsEncodableWithPreviousResponseId() throws {
        let requestBody = OpenAICreateResponseRequestBody(
            input: .items(
                [
                    .message(
                        role: .user,
                        content: .text("Tell me another joke")
                    ),
                ]
            ),
            model: "gpt-4o",
            previousResponseId: "1234"
        )
        XCTAssertEqual(
                """
                {
                  "input" : [
                    {
                      "content" : "Tell me another joke",
                      "role" : "user",
                      "type" : "message"
                    }
                  ],
                  "model" : "gpt-4o",
                  "previous_response_id" : "1234"
                }
                """, try requestBody.serialize(pretty: true))
    }

}

