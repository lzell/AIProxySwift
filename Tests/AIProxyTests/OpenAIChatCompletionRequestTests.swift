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
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()

    func testStreamOptionsIsEncodable() throws {
        let streamOptions = OpenAIChatStreamOptions(includeUsage: true)
        let jsonData = try self.jsonEncoder.encode(streamOptions)
        XCTAssertEqual(
            #"{"include_usage":true}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testResponseFormatIsEncodable() throws {
        let responseFormat = OpenAIChatResponseFormat.type("json_object")
        let jsonData = try jsonEncoder.encode(responseFormat)
        XCTAssertEqual(
            #"{"type":"json_object"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testTextChatContentPartIsEncodable() throws {
        let chatContentPart: OpenAIChatContentPart = .text("abc")
        let jsonData = try jsonEncoder.encode(chatContentPart)
        XCTAssertEqual(
            #"{"text":"abc","type":"text"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testImageChatContentPartIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.openAIEncodedImage(image: image)!
        let chatContentPart: OpenAIChatContentPart = .imageURL(localURL)
        let jsonData = try jsonEncoder.encode(chatContentPart)
        XCTAssertEqual(
            #"{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="},"type":"image_url"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatContentOfSingleTextIsEncodable() throws {
        let chatContent: OpenAIChatContent = .text("abc")
        let jsonData = try jsonEncoder.encode(chatContent)
        XCTAssertEqual(
            #""abc""#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatContentOfMultipleTextIsEncodable() throws {
        let chatContent: OpenAIChatContent = .parts([
            .text("a"),
            .text("b")
        ])
        let jsonData = try jsonEncoder.encode(chatContent)
        XCTAssertEqual(
            #"[{"text":"a","type":"text"},{"text":"b","type":"text"}]"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatContentContainingImageIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.openAIEncodedImage(image: image)!
        let chatContent: OpenAIChatContent = .parts([
            .text("hello"),
            .imageURL(localURL)
        ])
        let jsonData = try jsonEncoder.encode(chatContent)
        XCTAssertEqual(
            #"[{"text":"hello","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="},"type":"image_url"}]"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatMessageWithTextContentIsEncodable() throws {
        let chatMessage = OpenAIChatMessage(role: "user", content: .text("hello"))
        let jsonData = try jsonEncoder.encode(chatMessage)
        XCTAssertEqual(
            #"{"content":"hello","role":"user"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatMessageWithMultipleTextContentIsEncodable() throws {
        let chatMessage = OpenAIChatMessage(
            role: "user",
            content: .parts(
                [
                    .text("A"),
                    .text("B")
                ]
            )
        )
        let jsonData = try jsonEncoder.encode(chatMessage)
        XCTAssertEqual(
            #"{"content":[{"text":"A","type":"text"},{"text":"B","type":"text"}],"role":"user"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatMessageWithImageURLIsEncodable() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.openAIEncodedImage(image: image)!
        let chatMessage = OpenAIChatMessage(
            role: "user",
            content: .parts(
                [
                    .text("A"),
                    .imageURL(localURL)
                ]
            )
        )
        let jsonData = try jsonEncoder.encode(chatMessage)
        XCTAssertEqual(
            #"{"content":[{"text":"A","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="},"type":"image_url"}],"role":"user"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testBasicChatCompletionRequestBodyIsEncodableToJson() throws {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        )

        let jsonData = try self.jsonEncoder.encode(chatRequestBody)
        XCTAssertEqual(
            #"{"messages":[{"content":"hello world","role":"system"}],"model":"gpt-4o"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatCompletionRequestBodyWithOptionsIsEncodableToJson() throws {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))],
            temperature: 0.5,
            topP: 0.1
        )

        let jsonData = try self.jsonEncoder.encode(chatRequestBody)
        XCTAssertEqual(
            #"{"messages":[{"content":"hello world","role":"system"}],"model":"gpt-4o","temperature":0.5,"top_p":0.1}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testBasicStreamingChatCompletionRequestBodyIsEncodableToJson() throws {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))],
            stream: true,
            streamOptions: .init(includeUsage: true)
        )

        let jsonData = try self.jsonEncoder.encode(chatRequestBody)
        XCTAssertEqual(
            #"{"messages":[{"content":"hello world","role":"system"}],"model":"gpt-4o","stream":true,"stream_options":{"include_usage":true}}"#,
            String(data: jsonData, encoding: .utf8)
        )

    }

    func testChatCompletionRequestWithResponseFormatIsEncodableToJson() throws {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("return JSON only"))],
            responseFormat: .type("json_object")
        )

        let jsonData = try self.jsonEncoder.encode(chatRequestBody)
        XCTAssertEqual(
            #"{"messages":[{"content":"return JSON only","role":"system"}],"model":"gpt-4o","response_format":{"type":"json_object"}}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }

    func testChatCompletionRequestBodyWithImageIsEncodableToJson() throws {
        let image = createImage(width: 1, height: 1)
        let localURL = AIProxy.openAIEncodedImage(image: image)!
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .init(
                    role: "system",
                    content: .text("You are a plant identifier")
                ),
                .init(
                    role: "user",
                    content: .parts(
                        [
                            .text("What type of plant is this?"),
                            .imageURL(localURL)
                        ]
                    )
                )
            ]
        )

        let jsonData = try self.jsonEncoder.encode(chatRequestBody)
        XCTAssertEqual(
            #"{"messages":[{"content":"You are a plant identifier","role":"system"},{"content":[{"text":"What type of plant is this?","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+\/8AAEQgAAQABAwERAAIRAQMRAf\/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC\/\/EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29\/j5+v\/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC\/\/EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29\/j5+v\/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf\/dAAQAAf\/aAAwDAQACEQMRAD8A\/F+v8pz\/AL+D\/9k="},"type":"image_url"}],"role":"user"}],"model":"gpt-4o"}"#,
            String(data: jsonData, encoding: .utf8)
        )
    }
}
