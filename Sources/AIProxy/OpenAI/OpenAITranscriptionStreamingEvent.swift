//
//  OpenAITranscriptionStreamingEvent.swift
//  AIProxy
//

import Foundation

/// Represents a server-sent event from the OpenAI create transcription endpoint.
/// https://platform.openai.com/docs/api-reference/audio/createTranscription
nonisolated public enum OpenAITranscriptionStreamingEvent: Decodable, Sendable {
    case textDelta(TextDelta)
    case textDone(TextDone)
    case textSegment(OpenAICreateTranscriptionResponseBody.DiarizedSegment)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "transcript.text.delta":
            self = .textDelta(try TextDelta(from: decoder))
        case "transcript.text.done":
            self = .textDone(try TextDone(from: decoder))
        case "transcript.text.segment":
            self = .textSegment(try OpenAICreateTranscriptionResponseBody.DiarizedSegment(from: decoder))
        default:
            logIf(.info)?.info("Received unknown OpenAI transcription stream event of type \(type).")
            self = .futureProof
        }
    }
}

extension OpenAITranscriptionStreamingEvent {
    nonisolated public struct TextDelta: Decodable, Sendable {
        /// Incremental transcript text for this event.
        public let delta: String

        /// When present (for example with diarized streaming), ties this delta to a `transcript.text.segment` by id.
        public let segmentID: String?

        public let logprobs: [OpenAITranscriptionLogprob]?

        private enum CodingKeys: String, CodingKey {
            case delta
            case segmentID = "segment_id"
            case logprobs
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.delta = try container.decode(String.self, forKey: .delta)
            self.segmentID = try container.decodeIfPresent(String.self, forKey: .segmentID)
            self.logprobs = try container.decodeIfPresent([OpenAITranscriptionLogprob].self, forKey: .logprobs)
        }
    }

    nonisolated public struct TextDone: Decodable, Sendable {
        public let text: String
        public let logprobs: [OpenAITranscriptionLogprob]?
        public let usage: OpenAITranscriptionUsage?
    }
}
