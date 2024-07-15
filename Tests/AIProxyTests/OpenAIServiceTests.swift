import XCTest
@testable import AIProxy

final class OpenAIServiceTests: XCTestCase {
    let jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()

    // MARK: - StreamOptions
    func testStreamOptionsIsEncodable() {
        let streamOptions = OpenAIChatStreamOptions(includeUsage: true)
        XCTAssertEqual(
            #"{"include_usage":true}"#,
            jsonEncode(streamOptions)
        )
    }

    // MARK: - ResponseFormat
    func testResponseFormatIsEncodable() {
        let responseFormat = OpenAIChatResponseFormat.type("json_object")
        XCTAssertEqual(
            #"{"type":"json_object"}"#,
            jsonEncode(responseFormat)
        )
    }

    // MARK: - ChatContentPart
    func testTextChatContentPartIsEncodable() {
        let chatContentPart: OpenAIChatContentPart = .text("abc")
        XCTAssertEqual(
            #"{"text":"abc","type":"text"}"#,
            jsonEncode(chatContentPart)
        )
    }

    func testImageChatContentPartIsEncodable() {
        let image = create1x1Image()
        let localURL = createOpenAILocalURL(forImage: image)!
        let chatContentPart: OpenAIChatContentPart = .imageURL(localURL)
        XCTAssertEqual(
            #"{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBARXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/wAARCAABAAEDASIAAhEBAxEB\/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL\/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6\/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL\/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6\/9sAQwACAgICAgIDAgIDBQMDAwUGBQUFBQYIBgYGBgYICggICAgICAoKCgoKCgoKDAwMDAwMDg4ODg4PDw8PDw8PDw8P\/9sAQwECAgIEBAQHBAQHEAsJCxAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ\/90ABAAB\/9oADAMBAAIRAxEAPwD9SKKKKAP\/2Q=="},"type":"image_url"}"#,
            jsonEncode(chatContentPart)
        )
    }

    // MARK: - ChatContent
    func testChatContentOfSingleTextIsEncodable() {
        let chatContent: OpenAIChatContent = .text("abc")
        XCTAssertEqual(
            #""abc""#,
            jsonEncode(chatContent)
        )
    }

    func testChatContentOfMultipleTextIsEncodable() {
        let chatContent: OpenAIChatContent = .parts([
            .text("a"),
            .text("b")
        ])
        XCTAssertEqual(
            #"[{"text":"a","type":"text"},{"text":"b","type":"text"}]"#,
            jsonEncode(chatContent)
        )
    }

    func testChatContentContainingImageIsEncodable() {
        let image = create1x1Image()
        let localURL = createOpenAILocalURL(forImage: image)!
        let chatContent: OpenAIChatContent = .parts([
            .text("hello"),
            .imageURL(localURL)
        ])
        XCTAssertEqual(
            #"[{"text":"hello","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBARXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/wAARCAABAAEDASIAAhEBAxEB\/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL\/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6\/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL\/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6\/9sAQwACAgICAgIDAgIDBQMDAwUGBQUFBQYIBgYGBgYICggICAgICAoKCgoKCgoKDAwMDAwMDg4ODg4PDw8PDw8PDw8P\/9sAQwECAgIEBAQHBAQHEAsJCxAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ\/90ABAAB\/9oADAMBAAIRAxEAPwD9SKKKKAP\/2Q=="},"type":"image_url"}]"#,
            jsonEncode(chatContent)
        )
    }


    // MARK: - ChatMessage
    func testChatMessageWithTextContentIsEncodable() {
        let chatMessage = OpenAIChatMessage(role: "user", content: .text("hello"))
        XCTAssertEqual(
            #"{"content":"hello","role":"user"}"#,
            jsonEncode(chatMessage)
        )
    }

    func testChatMessageWithMultipleTextContentIsEncodable() {
        let chatMessage = OpenAIChatMessage(
            role: "user",
            content: .parts(
                [
                    .text("A"),
                    .text("B")
                ]
            )
        )
        XCTAssertEqual(
            #"{"content":[{"text":"A","type":"text"},{"text":"B","type":"text"}],"role":"user"}"#,
            jsonEncode(chatMessage)
        )
    }

    func testChatMessageWithImageURLIsEncodable() {
        let image = create1x1Image()
        let localURL = createOpenAILocalURL(forImage: image)!
        let chatMessage = OpenAIChatMessage(
            role: "user",
            content: .parts(
                [
                    .text("A"),
                    .imageURL(localURL)
                ]
            )
        )
        XCTAssertEqual(
            #"{"content":[{"text":"A","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBARXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/wAARCAABAAEDASIAAhEBAxEB\/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL\/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6\/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL\/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6\/9sAQwACAgICAgIDAgIDBQMDAwUGBQUFBQYIBgYGBgYICggICAgICAoKCgoKCgoKDAwMDAwMDg4ODg4PDw8PDw8PDw8P\/9sAQwECAgIEBAQHBAQHEAsJCxAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ\/90ABAAB\/9oADAMBAAIRAxEAPwD9SKKKKAP\/2Q=="},"type":"image_url"}],"role":"user"}"#,
            jsonEncode(chatMessage)
        )
    }


    func testBasicChatCompletionRequestBodyIsEncodableToJson() {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        if let jsonData = try? encoder.encode(chatRequestBody),
            let jsonStr = String(data: jsonData, encoding: .utf8) {
            XCTAssertEqual(jsonStr, #"{"messages":[{"content":"hello world","role":"system"}],"model":"gpt-4o"}"#)
        } else {
            XCTFail()
        }
    }

    func testBasicStreamingChatCompletionRequestBodyIsEncodableToJson() {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))],
            stream: true,
            streamOptions: .init(includeUsage: true)
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        if let jsonData = try? encoder.encode(chatRequestBody),
            let jsonStr = String(data: jsonData, encoding: .utf8) {
            XCTAssertEqual(jsonStr, #"{"messages":[{"content":"hello world","role":"system"}],"model":"gpt-4o","stream":true,"stream_options":{"include_usage":true}}"#)
        } else {
            XCTFail()
        }
    }

    func testChatCompletionRequestWithResponseFormatIsEncodableToJson() {
        let chatRequestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("return JSON only"))],
            responseFormat: .type("json_object")
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        if let jsonData = try? encoder.encode(chatRequestBody),
            let jsonStr = String(data: jsonData, encoding: .utf8) {
            XCTAssertEqual(jsonStr, #"{"messages":[{"content":"return JSON only","role":"system"}],"model":"gpt-4o","response_format":{"type":"json_object"}}"#)
        } else {
            XCTFail()
        }
    }


    func testChatCompletionRequestBodyWithImageIsEncodableToJson() {
        let image = create1x1Image()
        let localURL = createOpenAILocalURL(forImage: image)!
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

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        if let jsonData = try? encoder.encode(chatRequestBody),
            let jsonStr = String(data: jsonData, encoding: .utf8) {
            XCTAssertEqual(jsonStr, #"{"messages":[{"content":"You are a plant identifier","role":"system"},{"content":[{"text":"What type of plant is this?","type":"text"},{"image_url":{"url":"data:image\/jpeg;base64,\/9j\/4AAQSkZJRgABAQAASABIAAD\/4QBARXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD\/wAARCAABAAEDASIAAhEBAxEB\/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL\/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6\/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL\/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6\/9sAQwACAgICAgIDAgIDBQMDAwUGBQUFBQYIBgYGBgYICggICAgICAoKCgoKCgoKDAwMDAwMDg4ODg4PDw8PDw8PDw8P\/9sAQwECAgIEBAQHBAQHEAsJCxAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ\/90ABAAB\/9oADAMBAAIRAxEAPwD9SKKKKAP\/2Q=="},"type":"image_url"}],"role":"user"}],"model":"gpt-4o"}"#)
        } else {
            XCTFail()
        }
    }

    func testChatCompletionResponseBodyIsDecodable() {
        let sampleResponse = """
{
  "id": "chatcmpl-9Z8TAXo6bxOBAFgLghnhv8vzjmh5j",
  "object": "chat.completion",
  "created": 1718161064,
  "model": "gpt-4o-2024-05-13",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The image is a blank gray square"
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 276,
    "completion_tokens": 29,
    "total_tokens": 305
  },
  "system_fingerprint": "fp_aa87380ac5"
}
"""
        let decoder = JSONDecoder()

        let res = try! decoder.decode(OpenAIChatCompletionResponseBody.self, from: sampleResponse.data(using: .utf8)!)
        XCTAssertEqual("gpt-4o-2024-05-13", res.model)
        XCTAssertEqual("The image is a blank gray square", res.choices.first?.message.content)
    }

    func testChatCompletionResponseChunkIsDecodable() {
        let line = """
        data: {"id":"chatcmpl-9jAXUtD5xAKjjgo3XBZEawyoRdUGk","object":"chat.completion.chunk","created":1720552300,"model":"gpt-3.5-turbo-0125","system_fingerprint":null,"choices":[{"index":0,"delta":{"content":"FINDME"},"logprobs":null,"finish_reason":null}],"usage":null}
        """
        let res = OpenAIChatCompletionChunk.from(line: line)!
        XCTAssertEqual("FINDME", res.choices.first?.delta.content!)
    }

    func testCreateImageResponseIsDecodable() {
        let sampleResponse = """
        {
          "created": 1721071915,
          "data": [
            {
              "revised_prompt": "An outdoor winter scene.",
              "url": "https://api.example.com/image.png"
            }
          ]
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(OpenAICreateImageResponseBody.self, from: sampleResponse.data(using: .utf8)!)
        XCTAssertEqual("An outdoor winter scene.", res.data.first?.revisedPrompt)
        XCTAssertEqual(URL(string: "https://api.example.com/image.png")!, res.data.first?.url)

    }


#if false // E2E tests
    func testBadPartialKeyReturnsBadStatusCode() async {
        let service = OpenAIService(
            partialKey: "bad|format"
        )

        let body = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        )

        do {
            _ = try await service.chatCompletionRequest(body: body)
            XCTFail("We expected a raised error")
        } catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            XCTAssertEqual(#"{"error":{"message":"The partial key header is missing parts"}}"#, responseBody!)
            XCTAssertEqual(403, statusCode)
        } catch {
            XCTFail("We expected an AIProxyError")
        }
    }

    func testE2EChatCompletionBasic() async {
        let service = OpenAIService(
            partialKey: "<snip>"
        )

        let body = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        )

        let response = try! await service.chatCompletionRequest(body: body)
        XCTAssertEqual("gpt-4o-2024-05-13", response.model)
    }

    func testE2EChatCompletionWithImage() async {
        let service = OpenAIService(
            partialKey: "<snip>"
        )

        let image = create1x1Image()
        let localURL = createOpenAILocalURL(forImage: image)!

        let body = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .init(
                    role: "system",
                    content: .text("Tell me what you see")
                ),
                .init(
                    role: "user",
                    content: .parts(
                        [
                            .text("What do you see?"),
                            .imageURL(localURL)
                        ]
                    )
                )
            ]
        )

        let response = try! await service.chatCompletionRequest(body: body)
        XCTAssertEqual("gpt-4o-2024-05-13", response.model)
    }
#endif // End E2E tests

    private func jsonEncode(_ encodable: Encodable) -> String {
        let data = try! self.jsonEncoder.encode(encodable)
        return String(data: data, encoding: .utf8)!
    }
}



func create1x1Image() -> CGImage {
    return createTestImage(size: 1)
}

func createTestImage(size: Int) -> CGImage {
    let height = size
    let width = size
    let numComponents = 3
    let numBytes = height * width * numComponents
    let pixelData = [UInt8](repeating: 210, count: numBytes)
    let colorspace = CGColorSpaceCreateDeviceRGB()
    let rgbData = CFDataCreate(nil, pixelData, numBytes)!
    let provider = CGDataProvider(data: rgbData)!
    return CGImage(width: width,
                   height: height,
                   bitsPerComponent: 8,
                   bitsPerPixel: 8 * numComponents,
                   bytesPerRow: width * numComponents,
                   space: colorspace,
                   bitmapInfo: CGBitmapInfo(rawValue: 0),
                   provider: provider,
                   decode: nil,
                   shouldInterpolate: true,
                   intent: CGColorRenderingIntent.defaultIntent)!
}


private extension CGImage {

    var jpegData: Data {
        let bitmapRep = NSBitmapImageRep(cgImage: self)
        return bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
    }
}

func createOpenAILocalURL(forImage image: CGImage) -> URL? {
    let base64String = image.jpegData.base64EncodedString()
    return URL(string: "data:image/jpeg;base64,\(base64String)")
}
