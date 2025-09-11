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
///   - https://platform.openai.com/docs/api-reference/audio/verbose-json-object
///   - https://platform.openai.com/docs/api-reference/audio/json-object
///
/// If you would like all properties to be populated, make sure to set the response format to `verbose_json` when you
/// create the request body. See the docstring on `OpenAICreateTranscriptionRequestBody` for details.
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

    public init(text: String, language: String?, duration: Double?, words: [Word]?, segments: [Segment]?) {
        self.text = text
        self.language = language
        self.duration = duration
        self.words = words
        self.segments = segments
    }

    enum CodingKeys: String, CodingKey {
        case text
        case language
        case duration
        case words
        case segments
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

        public init(seek: Int, start: Double, end: Double, text: String, tokens: [Int], temperature: Double, avgLogprob: Double, compressionRatio: Double, noSpeechProb: Double) {
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

