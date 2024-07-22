import XCTest
import Foundation
@testable import AIProxy


final class OpenAIAudioCodablesTests: XCTestCase {

    func testAudioTranscriptBodyIsFormEncodable() {
        let body = OpenAICreateTranscriptionRequestBody(
            file: "AUDIO".data(using: .utf8)!,
            model: "whisper-1"
        )

        let boundary = UUID().uuidString
        let result = formEncode(body, boundary)

        let expected = """
        --\(boundary)\r
        Content-Disposition: form-data; name="file"; filename="aiproxy.m4a"\r
        Content-Type: audio/mpeg\r
        \r
        AUDIO\r
        --\(boundary)\r
        Content-Disposition: form-data; name="model"\r
        \r
        whisper-1\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }

    func testAudioTranscriptResponseIsDecodableWithWordTimestampGranularities() {
        let sampleResponse = """
        {
          "task": "transcribe",
          "language": "english",
          "duration": 2.4200000762939453,
          "text": "Hello, world.",
          "words": [
            {
              "word": "Hello",
              "start": 0.8999999761581421,
              "end": 1.4600000381469727
            },
            {
              "word": "world",
              "start": 1.8200000524520874,
              "end": 2.0199999809265137
            }
          ]
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        XCTAssertEqual("Hello", res.words!.first!.word)
    }


    func testAudioTranscriptResponseIsDecodableWithSegmentTimestampGranularities() {
        let sampleResponse = """
        {
          "task": "transcribe",
          "language": "english",
          "duration": 2.4200000762939453,
          "text": "Hello, world.",
          "segments": [
            {
              "id": 0,
              "seek": 0,
              "start": 0.0,
              "end": 2.0,
              "text": "Hello, world.",
              "tokens": [
                50364,
                2425,
                11,
                1002,
                13,
                50464
              ],
              "temperature": 0.0,
              "avg_logprob": -0.652007520198822,
              "compression_ratio": 0.6190476417541504,
              "no_speech_prob": 0.0786471739411354
            }
          ]
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        XCTAssertEqual("Hello, world.", res.segments!.first!.text)
    }
}
