//
//  OpenAIChatCompletionRequestTests.swift
//
//
//  Created by Lou Zell on 8/11/24.
//

import XCTest
@testable import AIProxy

final class OpenAIChatCompletionRequestTests: XCTestCase {

    let jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        return encoder
    }()

    func testStreamOptionsIsEncodable() throws {
        let streamOptions = OpenAIChatCompletionRequestBody.StreamOptions(includeUsage: true)
        XCTAssertEqual(
            """
            {
              "include_usage" : true
            }
            """,
            try streamOptions.serialize(pretty: true)
        )
    }

    func testResponseFormatIsEncodable() throws {
        let responseFormat = OpenAIChatCompletionRequestBody.ResponseFormat.jsonObject
        XCTAssertEqual(
            """
            {
              "type" : "json_object"
            }
            """,
            try responseFormat.serialize(pretty: true)
        )
    }

    func testTextChatContentPartIsEncodable() throws {
        let chatContentPart: OpenAIChatCompletionRequestBody.Message.UserContent.Part = .text("abc")
        XCTAssertEqual(
            """
            {
              "text" : "abc",
              "type" : "text"
            }
            """,
            try chatContentPart.serialize(pretty: true)
        )
    }

    func testImageChatContentPartIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.encodeImageAsURL(image: image)!
        let chatContentPart: OpenAIChatCompletionRequestBody.Message.UserContent.Part = .imageURL(localURL)
        XCTAssertEqual(
            #"""
            {
              "image_url" : {
                "url" : "data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="
              },
              "type" : "image_url"
            }
            """#,
            try chatContentPart.serialize(pretty: true)
        )
    }

    func testChatContentOfMultipleTextIsEncodable() throws {
        let chatContent: [OpenAIChatCompletionRequestBody.Message.UserContent.Part] = [
            .text("a"),
            .text("b")
        ]
        XCTAssertEqual(
            """
            [
              {
                "text" : "a",
                "type" : "text"
              },
              {
                "text" : "b",
                "type" : "text"
              }
            ]
            """,
            try chatContent.serialize(pretty: true)
        )
    }

    func testChatContentContainingImageIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.encodeImageAsURL(image: image)!
        let chatContent: [OpenAIChatCompletionRequestBody.Message.UserContent.Part] = [
            .text("hello"),
            .imageURL(localURL)
        ]
        XCTAssertEqual(
            #"""
            [
              {
                "text" : "hello",
                "type" : "text"
              },
              {
                "image_url" : {
                  "url" : "data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="
                },
                "type" : "image_url"
              }
            ]
            """#,
            try chatContent.serialize(pretty: true)
        )
    }

    func testUserMessageWithTextContentIsEncodable() throws {
        let userMessage: OpenAIChatCompletionRequestBody.Message = .user(content: .text("hello"))
        XCTAssertEqual(
            """
            {
              "content" : "hello",
              "role" : "user"
            }
            """,
            try userMessage.serialize(pretty: true)
        )
    }

    func testUserMessageWithMultipleTextContentIsEncodable() throws {
        let userMessage: OpenAIChatCompletionRequestBody.Message = .user(content: .parts(
            [
                .text("A"),
                .text("B")
            ]
        ))
        XCTAssertEqual(
            """
            {
              "content" : [
                {
                  "text" : "A",
                  "type" : "text"
                },
                {
                  "text" : "B",
                  "type" : "text"
                }
              ],
              "role" : "user"
            }
            """,
            try userMessage.serialize(pretty: true)
        )
    }

    func testUserMessageWithImageURLIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.encodeImageAsURL(image: image)!
        let userMessage: OpenAIChatCompletionRequestBody.Message = .user(
            content: .parts(
                [
                    .text("A"),
                    .imageURL(localURL)
                ]
            )
        )
        XCTAssertEqual(
            #"""
            {
              "content" : [
                {
                  "text" : "A",
                  "type" : "text"
                },
                {
                  "image_url" : {
                    "url" : "data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="
                  },
                  "type" : "image_url"
                }
              ],
              "role" : "user"
            }
            """#,
            try userMessage.serialize(pretty: true)
        )
    }

    func testMessageArrayOfUserAndSystemIsEncodable() throws {
        let messages: [OpenAIChatCompletionRequestBody.Message] = [
            .system(content: .text("hello")),
            .user(content: .text("hello"))
        ]
        XCTAssertEqual(
            """
            [
              {
                "content" : "hello",
                "role" : "system"
              },
              {
                "content" : "hello",
                "role" : "user"
              }
            ]
            """,
            try messages.serialize(pretty: true)
        )
    }

    func testBasicChatCompletionRequestBodyIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .system(content: .text("hello world"))
            ]
        )
        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "hello world",
                  "role" : "system"
                }
              ],
              "model" : "gpt-4o"
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testChatCompletionRequestBodyWithOptionsIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.system(content: .text("hello world"))],
            temperature: 0.5,
            topP: 0.1
        )
        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "hello world",
                  "role" : "system"
                }
              ],
              "model" : "gpt-4o",
              "temperature" : 0.5,
              "top_p" : 0.1
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testBasicStreamingChatCompletionRequestBodyIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.system(content: .text("hello world"))],
            stream: true,
            streamOptions: .init(includeUsage: true)
        )
        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "hello world",
                  "role" : "system"
                }
              ],
              "model" : "gpt-4o",
              "stream" : true,
              "stream_options" : {
                "include_usage" : true
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )

    }

    func testChatCompletionRequestWithJSONModeIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.system(content: .text("return JSON only"))],
            responseFormat: .jsonObject
        )
        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "return JSON only",
                  "role" : "system"
                }
              ],
              "model" : "gpt-4o",
              "response_format" : {
                "type" : "json_object"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testChatCompletionRequestWithStructuredOutputsIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.system(content: .text("return JSON only"))],
            responseFormat: .jsonSchema(
                name: "my-schema",
                description: "the description",
                schema: ["x": "y"],
                strict: true
            )
        )
        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "return JSON only",
                  "role" : "system"
                }
              ],
              "model" : "gpt-4o",
              "response_format" : {
                "json_schema" : {
                  "description" : "the description",
                  "name" : "my-schema",
                  "schema" : {
                    "x" : "y"
                  },
                  "strict" : true
                },
                "type" : "json_schema"
              }
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }

    func testToolChoiceIsEncodable() throws {
        XCTAssertEqual(
            #""auto""#,
            try OpenAIChatCompletionRequestBody.ToolChoice.auto.serialize()
        )
        XCTAssertEqual(
            #""none""#,
            try OpenAIChatCompletionRequestBody.ToolChoice.none.serialize()
        )
        XCTAssertEqual(
            #""required""#,
            try OpenAIChatCompletionRequestBody.ToolChoice.required.serialize()
        )
        XCTAssertEqual(
            """
            {
              "function" : {
                "name" : "xyz"
              },
              "type" : "function"
            }
            """,
            try OpenAIChatCompletionRequestBody.ToolChoice.specific(functionName: "xyz").serialize(pretty: true)
        )
    }

    func testChatCompletionRequestWithToolsIsEncodableToJson() throws {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .system(content: .text("You are a helpful assistant that calls functions")),
                .user(content: .text("look up all my orders in may of last year"))
            ],
            tools: [
                .function(
                    name: "query",
                    description: "Execute a query.",
                    parameters: ["x": "y"],
                    strict: true
                )
            ],
            toolChoice: .required
        )

        XCTAssertEqual(
            """
            {
              "messages" : [
                {
                  "content" : "You are a helpful assistant that calls functions",
                  "role" : "system"
                },
                {
                  "content" : "look up all my orders in may of last year",
                  "role" : "user"
                }
              ],
              "model" : "gpt-4o",
              "tool_choice" : "required",
              "tools" : [
                {
                  "function" : {
                    "description" : "Execute a query.",
                    "name" : "query",
                    "parameters" : {
                      "x" : "y"
                    },
                    "strict" : true
                  },
                  "type" : "function"
                }
              ]
            }
            """,
            try requestBody.serialize(pretty: true)
        )
    }


    func testChatCompletionRequestBodyWithImageIsEncodableToJson() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.openAIEncodedImage(image: image)!
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .system(
                    content: .text("You are a plant identifier")
                ),
                .user(
                    content: .parts(
                        [
                            .text("What type of plant is this?"),
                            .imageURL(localURL)
                        ]
                    )
                )
            ]
        )

        XCTAssertEqual(
            #"""
            {
              "messages" : [
                {
                  "content" : "You are a plant identifier",
                  "role" : "system"
                },
                {
                  "content" : [
                    {
                      "text" : "What type of plant is this?",
                      "type" : "text"
                    },
                    {
                      "image_url" : {
                        "url" : "data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="
                      },
                      "type" : "image_url"
                    }
                  ],
                  "role" : "user"
                }
              ],
              "model" : "gpt-4o"
            }
            """#,
            try requestBody.serialize(pretty: true)
        )
    }

    func testResponseFormatIsEncodableForStructuredOutputs() throws {
        // This schema is taken from the OpenAI guide here:
        // https://platform.openai.com/docs/guides/structured-outputs/examples?context=ex2
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
              "title": [ "type": "string" ],
              "authors": [
                "type": "array",
                "items": [ "type": "string" ]
              ],
              "abstract": [ "type": "string" ],
              "keywords": [
                "type": "array",
                "items": [ "type": "string" ]
              ]
            ],
            "required": ["title", "authors", "abstract", "keywords"],
            "additionalProperties": false
        ]

        let responseFormat = OpenAIChatCompletionRequestBody.ResponseFormat.jsonSchema(
            name: "research_paper_extraction",
            schema: schema,
            strict: true
        )

        XCTAssertEqual(
            #"""
            {
              "json_schema" : {
                "name" : "research_paper_extraction",
                "schema" : {
                  "additionalProperties" : false,
                  "properties" : {
                    "abstract" : {
                      "type" : "string"
                    },
                    "authors" : {
                      "items" : {
                        "type" : "string"
                      },
                      "type" : "array"
                    },
                    "keywords" : {
                      "items" : {
                        "type" : "string"
                      },
                      "type" : "array"
                    },
                    "title" : {
                      "type" : "string"
                    }
                  },
                  "required" : [
                    "title",
                    "authors",
                    "abstract",
                    "keywords"
                  ],
                  "type" : "object"
                },
                "strict" : true
              },
              "type" : "json_schema"
            }
            """#,
            try responseFormat.serialize(pretty: true)
        )
    }
}
