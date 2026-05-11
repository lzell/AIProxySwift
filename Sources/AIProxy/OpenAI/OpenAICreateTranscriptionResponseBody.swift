//
//  OpenAICreateTranscriptionResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 2024-07-21.
//

import Foundation

/// The response body for create transcription requests.
///
/// This object is deserialized from one of:
///   - https://platform.openai.com/docs/api-reference/audio/json-object
///   - https://platform.openai.com/docs/api-reference/audio/verbose-json-object
///   - a `diarized_json` response from https://platform.openai.com/docs/api-reference/audio/createTranscription
///
/// Different response formats populate different fields:
/// - `json`: `text`, optional `usage`, and optional `logprobs` when requested via `include[]=logprobs`
/// - `verbose_json`: `text`, `language`, `duration`, optional `words`, optional `segments`, and optional duration usage
/// - `diarized_json`: `text`, `duration`, optional `diarizedSegments`, and optional duration usage
nonisolated public struct OpenAICreateTranscriptionResponseBody: Decodable, Sendable {
    public let text: String

    /// The language of the input audio.
    public let language: String?

    /// The duration of the input audio.
    public let duration: Double?

    /// Extracted words and their corresponding timestamps.
    public let words: [Word]?

    /// Segments of the transcribed text and their corresponding details.
    public let segments: [Segment]?

    /// Segments of a diarized transcription, including speaker labels.
    public let diarizedSegments: [DiarizedSegment]?

    /// The log probabilities of the tokens in the transcription.
    public let logprobs: [OpenAITranscriptionLogprob]?

    /// Usage statistics for the transcription request.
    /// Unlike the Responses API, transcription usage may be billed by tokens or by audio duration.
    public let usage: OpenAITranscriptionUsage?

    public init(
        text: String,
        language: String?,
        duration: Double?,
        words: [Word]?,
        segments: [Segment]?,
        diarizedSegments: [DiarizedSegment]? = nil,
        logprobs: [OpenAITranscriptionLogprob]? = nil,
        usage: OpenAITranscriptionUsage? = nil
    ) {
        self.text = text
        self.language = language
        self.duration = duration
        self.words = words
        self.segments = segments
        self.diarizedSegments = diarizedSegments
        self.logprobs = logprobs
        self.usage = usage
    }

    enum CodingKeys: String, CodingKey {
        case text
        case language
        case duration
        case words
        case segments
        case logprobs
        case usage
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.duration = try container.decodeIfPresent(Double.self, forKey: .duration)
        self.words = try container.decodeIfPresent([Word].self, forKey: .words)
        self.segments = try? container.decodeIfPresent([Segment].self, forKey: .segments)
        self.diarizedSegments = self.segments == nil
            ? (try? container.decodeIfPresent([DiarizedSegment].self, forKey: .segments))
            : nil
        self.logprobs = try container.decodeIfPresent([OpenAITranscriptionLogprob].self, forKey: .logprobs)
        self.usage = try container.decodeIfPresent(OpenAITranscriptionUsage.self, forKey: .usage)
    }
}

// MARK: -
extension OpenAICreateTranscriptionResponseBody {
    /// See https://platform.openai.com/docs/api-reference/audio/verbose-json-object#audio/verbose-json-object-words
    nonisolated public struct Word: Decodable, Sendable {
        /// The text content of the word.
        public let word: String

        /// Start time of the word in seconds.
        public let start: Double

        /// End time of the word in seconds.
        public let end: Double

        public init(word: String, start: Double, end: Double) {
            self.word = word
            self.start = start
            self.end = end
        }

        enum CodingKeys: String, CodingKey {
            case word
            case start
            case end
        }
    }
}

// MARK: -
extension OpenAICreateTranscriptionResponseBody {
    /// See https://platform.openai.com/docs/api-reference/audio/verbose-json-object#audio/verbose-json-object-segments
    nonisolated public struct Segment: Decodable, Sendable {
        /// Unique identifier of the segment.
        public let id: Int?

        /// Seek offset of the segment.
        public let seek: Int

        /// Start time of the segment in seconds.
        public let start: Double

        /// End time of the segment in seconds.
        public let end: Double

        /// Text content of the segment.
        public let text: String

        /// Array of token IDs for the text content.
        public let tokens: [Int]

        /// Temperature parameter used for generating the segment.
        public let temperature: Double

        /// Average logprob of the segment. If the value is lower than -1, consider the logprobs failed.
        public let avgLogprob: Double

        /// Compression ratio of the segment. If the value is greater than 2.4, consider the compression failed.
        public let compressionRatio: Double

        /// Probability of no speech in the segment. If the value is higher than 1.0 and the avg_logprob is below -1, consider this segment silent.
        public let noSpeechProb: Double

        public init(
            id: Int? = nil,
            seek: Int,
            start: Double,
            end: Double,
            text: String,
            tokens: [Int],
            temperature: Double,
            avgLogprob: Double,
            compressionRatio: Double,
            noSpeechProb: Double
        ) {
            self.id = id
            self.seek = seek
            self.start = start
            self.end = end
            self.text = text
            self.tokens = tokens
            self.temperature = temperature
            self.avgLogprob = avgLogprob
            self.compressionRatio = compressionRatio
            self.noSpeechProb = noSpeechProb
        }

        enum CodingKeys: String, CodingKey {
            case id
            case seek
            case start
            case end
            case text
            case tokens
            case temperature
            case avgLogprob = "avg_logprob"
            case compressionRatio = "compression_ratio"
            case noSpeechProb = "no_speech_prob"
        }
    }
}

// MARK: -
extension OpenAICreateTranscriptionResponseBody {
    /// See https://platform.openai.com/docs/api-reference/audio/createTranscription for the diarized_json response shape.
    nonisolated public struct DiarizedSegment: Decodable, Sendable {
        public let type: String?
        public let id: String?
        public let start: Double
        public let end: Double
        public let text: String
        public let speaker: String?
    }
}

