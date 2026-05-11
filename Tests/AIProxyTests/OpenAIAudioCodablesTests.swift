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

    func testAudioTranscriptBodyEncodesIncludeFields() {
        let body = OpenAICreateTranscriptionRequestBody(
            file: "AUDIO".data(using: .utf8)!,
            model: "gpt-4o-transcribe",
            responseFormat: "json",
            include: [.logprobs]
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
        gpt-4o-transcribe\r
        --\(boundary)\r
        Content-Disposition: form-data; name="response_format"\r
        \r
        json\r
        --\(boundary)\r
        Content-Disposition: form-data; name="include[]"\r
        \r
        logprobs\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }

    func testAudioTranscriptBodyEncodesStreamingAndDiarizationFields() {
        let body = OpenAICreateTranscriptionRequestBody(
            file: "AUDIO".data(using: .utf8)!,
            model: "gpt-4o-transcribe-diarize",
            responseFormat: "diarized_json",
            stream: true,
            chunkingStrategy: .auto,
            knownSpeakerNames: ["agent"],
            knownSpeakerReferences: ["data:audio/wav;base64,AAA..."]
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
        gpt-4o-transcribe-diarize\r
        --\(boundary)\r
        Content-Disposition: form-data; name="response_format"\r
        \r
        diarized_json\r
        --\(boundary)\r
        Content-Disposition: form-data; name="stream"\r
        \r
        true\r
        --\(boundary)\r
        Content-Disposition: form-data; name="chunking_strategy"\r
        \r
        auto\r
        --\(boundary)\r
        Content-Disposition: form-data; name="known_speaker_names[]"\r
        \r
        agent\r
        --\(boundary)\r
        Content-Disposition: form-data; name="known_speaker_references[]"\r
        \r
        data:audio/wav;base64,AAA...\r
        --\(boundary)--
        """
        XCTAssertEqual(expected, String(data: result, encoding: .utf8)!)
    }

    func testAudioTranscriptBodyEncodesServerVADChunkingStrategy() {
        let body = OpenAICreateTranscriptionRequestBody(
            file: "AUDIO".data(using: .utf8)!,
            model: "gpt-4o-transcribe",
            chunkingStrategy: .serverVAD(
                .init(
                    prefixPaddingMs: 250,
                    silenceDurationMs: 700,
                    threshold: 0.4
                )
            )
        )

        let boundary = UUID().uuidString
        let result = String(data: formEncode(body, boundary), encoding: .utf8)!

        XCTAssertTrue(result.contains(#"Content-Disposition: form-data; name="chunking_strategy""#))
        XCTAssertTrue(result.contains(#"{"type":"server_vad","prefix_padding_ms":250,"silence_duration_ms":700,"threshold":0.4}"#))
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

    func testAudioTranscriptResponseIsDecodableWithTokenUsageAndLogprobs() {
        let sampleResponse = """
        {
          "text": "Hello, world.",
          "logprobs": [
            {
              "token": "Hello",
              "bytes": [72, 101, 108, 108, 111],
              "logprob": -0.1
            }
          ],
          "usage": {
            "type": "tokens",
            "input_tokens": 14,
            "input_token_details": {
              "text_tokens": 0,
              "audio_tokens": 14
            },
            "output_tokens": 3,
            "total_tokens": 17
          }
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        XCTAssertEqual("Hello, world.", res.text)
        XCTAssertEqual("Hello", res.logprobs?.first?.token)
        XCTAssertEqual([72, 101, 108, 108, 111], res.logprobs?.first?.bytes)
        switch res.usage?.type {
        case .tokens?:
            break
        default:
            XCTFail("Expected token-based transcription usage")
        }
        XCTAssertEqual(14, res.usage?.inputTokens)
        XCTAssertEqual(14, res.usage?.inputTokensDetails?.audioTokens)
        XCTAssertEqual(0, res.usage?.inputTokensDetails?.textTokens)
        XCTAssertEqual(3, res.usage?.outputTokens)
        XCTAssertEqual(17, res.usage?.totalTokens)
    }

    func testAudioTranscriptResponseInfersDurationUsageWhenTypeIsOmitted() {
        let sampleResponse = """
        {
          "text": "Hello",
          "usage": {
            "seconds": 9.5
          }
        }
        """
        let decoder = JSONDecoder()
        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        switch res.usage?.type {
        case .duration?:
            break
        default:
            XCTFail("Expected inferred duration usage")
        }
        XCTAssertEqual(9.5, res.usage?.seconds)
    }

    func testAudioTranscriptResponseUnknownUsageTypeIsFutureProof() {
        let sampleResponse = """
        {
          "text": "Hello",
          "usage": {
            "type": "credits",
            "credits_used": 3
          }
        }
        """
        let decoder = JSONDecoder()
        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        switch res.usage?.type {
        case .futureProof?:
            break
        default:
            XCTFail("Expected future-proof usage type")
        }
    }

    func testAudioTranscriptResponseIsDecodableWithSegmentTimestampGranularities() {
        let sampleResponse = """
        {
          "task": "transcribe",
          "language": "english",
          "duration": 2.4200000762939453,
          "text": "Hello, world.",
          "usage": {
            "type": "duration",
            "seconds": 2.42
          },
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
        switch res.usage?.type {
        case .duration?:
            break
        default:
            XCTFail("Expected duration-based transcription usage")
        }
        XCTAssertEqual(2.42, res.usage?.seconds)
        XCTAssertEqual(0, res.segments!.first!.id)
        XCTAssertEqual("Hello, world.", res.segments!.first!.text)
    }

    func testAudioTranscriptResponseIsDecodableWithDiarizedSegmentsAndDurationUsage() {
        let sampleResponse = """
        {
          "task": "transcribe",
          "duration": 27.4,
          "text": "Agent: Thanks for calling OpenAI support.",
          "segments": [
            {
              "type": "transcript.text.segment",
              "id": "seg_001",
              "start": 0.0,
              "end": 4.7,
              "text": "Thanks for calling OpenAI support.",
              "speaker": "agent"
            }
          ],
          "usage": {
            "type": "duration",
            "seconds": 27
          }
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(
            OpenAICreateTranscriptionResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        XCTAssertNil(res.segments)
        XCTAssertEqual("seg_001", res.diarizedSegments?.first?.id)
        XCTAssertEqual("agent", res.diarizedSegments?.first?.speaker)
        switch res.usage?.type {
        case .duration?:
            break
        default:
            XCTFail("Expected duration-based transcription usage")
        }
        XCTAssertEqual(27, res.usage?.seconds)
    }
}
