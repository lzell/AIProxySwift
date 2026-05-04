//
//  OpenAITranscriptionStreamingEventTests.swift
//  AIProxyTests
//

import Foundation
import Testing
@testable import AIProxy

struct OpenAITranscriptionStreamingEventTests {

    @Test
    func textDeltaIsDecodable() throws {
        let event = try decode(#"{"type":"transcript.text.delta","delta":"Hello"}"#)

        guard case .textDelta(let payload) = event else {
            Issue.record("Expected textDelta")
            return
        }
        #expect(payload.delta == "Hello")
        #expect(payload.logprobs == nil)
    }

    @Test
    func textDeltaLogprobsAreDecodable() throws {
        let event = try decode(
            #"{"type":"transcript.text.delta","delta":" Hi","logprobs":[{"token":" Hi","logprob":-0.001,"bytes":[32,72,105]}]}"#
        )

        guard case .textDelta(let payload) = event else {
            Issue.record("Expected textDelta")
            return
        }
        #expect(payload.delta == " Hi")
        #expect(payload.logprobs?.first?.token == " Hi")
        #expect(payload.logprobs?.first?.logprob == -0.001)
        #expect(payload.logprobs?.first?.bytes == [32, 72, 105])
    }

    @Test
    func textDeltaSegmentIdIsDecodable() throws {
        let event = try decode(
            #"{"type":"transcript.text.delta","delta":"Hi","segment_id":"seg_42"}"#
        )

        guard case .textDelta(let payload) = event else {
            Issue.record("Expected textDelta")
            return
        }
        #expect(payload.delta == "Hi")
        #expect(payload.segmentID == "seg_42")
    }

    @Test
    func unknownStreamingEventDecodesAsFutureProof() throws {
        let event = try decode(#"{"type":"transcript.unknown.event","foo":1}"#)
        guard case .futureProof = event else {
            Issue.record("Expected futureProof")
            return
        }
    }

    @Test
    func textDoneUsageAndLogprobsAreDecodableWhenUsageTypeIsOmitted() throws {
        let event = try decode(
            #"""
            {
              "type": "transcript.text.done",
              "text": "Hello there",
              "logprobs": [
                {
                  "token": "Hello",
                  "logprob": -0.02,
                  "bytes": [72, 101, 108, 108, 111]
                }
              ],
              "usage": {
                "input_tokens": 14,
                "input_token_details": {
                  "text_tokens": 0,
                  "audio_tokens": 14
                },
                "output_tokens": 3,
                "total_tokens": 17
              }
            }
            """#
        )

        guard case .textDone(let payload) = event else {
            Issue.record("Expected textDone")
            return
        }
        #expect(payload.text == "Hello there")
        #expect(payload.logprobs?.first?.token == "Hello")
        switch payload.usage?.type {
        case .tokens?:
            break
        default:
            Issue.record("Expected inferred token usage")
        }
        #expect(payload.usage?.inputTokens == 14)
        #expect(payload.usage?.inputTokensDetails?.audioTokens == 14)
        #expect(payload.usage?.inputTokensDetails?.textTokens == 0)
        #expect(payload.usage?.outputTokens == 3)
        #expect(payload.usage?.totalTokens == 17)
    }

    @Test
    func textSegmentIsDecodable() throws {
        let event = try decode(
            #"{"type":"transcript.text.segment","id":"seg_001","start":0.0,"end":4.7,"text":"Thanks for calling.","speaker":"agent"}"#
        )

        guard case .textSegment(let payload) = event else {
            Issue.record("Expected textSegment")
            return
        }
        #expect(payload.type == "transcript.text.segment")
        #expect(payload.id == "seg_001")
        #expect(payload.start == 0.0)
        #expect(payload.end == 4.7)
        #expect(payload.text == "Thanks for calling.")
        #expect(payload.speaker == "agent")
    }

    @Test
    func sseLineParsingIgnoresDoneSentinel() throws {
        let event = OpenAITranscriptionStreamingEvent.deserialize(
            fromLine: #"data: {"type":"transcript.text.delta","delta":"A"}"#
        )
        let done = OpenAITranscriptionStreamingEvent.deserialize(fromLine: "data: [DONE]")

        guard case .textDelta(let payload)? = event else {
            Issue.record("Expected textDelta")
            return
        }
        #expect(payload.delta == "A")
        #expect(done == nil)
    }

    private func decode(_ json: String) throws -> OpenAITranscriptionStreamingEvent {
        try JSONDecoder().decode(OpenAITranscriptionStreamingEvent.self, from: Data(json.utf8))
    }
}
