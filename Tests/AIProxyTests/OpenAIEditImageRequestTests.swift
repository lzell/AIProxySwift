//
//  OpenAIEditImageRequestTests.swift
//  AIProxy
//
//  Created by Lou Zell on 8/4/25.
//

import XCTest
@testable import AIProxy

final class OpenAIEditImageRequestTests: XCTestCase {

    func testRequestBodyIsEncodable() throws {
        let boundary = "my-boundary"
        let crlf = "\r\n"
        let image = createImage(width: 1, height: 1)
        let jpegData = AIProxy.encodeImageAsJpeg(image: image, compressionQuality: 1.0)!

        let requestBody = OpenAICreateImageEditRequestBody(
            images: [.jpeg(jpegData)],
            prompt: "Change the boat mast to red",
            inputFidelity: .high,
            model: .gptImage1
        )
        var expectedEncoding = Data()

        let fileIntro = """
        --\(boundary)
        Content-Disposition: form-data; name="image[]"; filename="tmpfile0"
        Content-Type: image/jpeg


        """.replacingOccurrences(of: "\n", with: crlf)

        expectedEncoding.append(Data(fileIntro.utf8))
        expectedEncoding.append(jpegData)
        expectedEncoding.append(Data(crlf.utf8))

        let remainingArguments = """
        --\(boundary)
        Content-Disposition: form-data; name="prompt"

        Change the boat mast to red
        --\(boundary)
        Content-Disposition: form-data; name="input_fidelity"

        high
        --\(boundary)
        Content-Disposition: form-data; name="model"

        gpt-image-1
        --\(boundary)--
        """.replacingOccurrences(of: "\n", with: crlf)
        expectedEncoding.append(Data(remainingArguments.utf8))

        XCTAssertEqual(
            expectedEncoding,
            formEncode(requestBody, boundary)
        )
    }
}
