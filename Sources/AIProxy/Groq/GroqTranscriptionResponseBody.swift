//
//  GroqTranscriptionResponseBody.swift
//
//
//  Created by Lou Zell on 10/2/24.
//

import Foundation

/// The response body for create transcription requests.
///
/// This object is deserialized from one of:
///   - https://platform.openai.com/docs/api-reference/audio/verbose-json-object
///   - https://platform.openai.com/docs/api-reference/audio/json-object
///
/// If you would like all properties to be populated, make sure to set the response format to `verbose_json` when you
/// create the request body. See the docstring on `GroqTranscriptionRequestBody` for details.
public struct GroqTranscriptionResponseBody: Decodable {
    /// The duration of the input audio.
    public let duration: Double?

    /// The language of the input audio.
    public let language: String?

    /// Segments of the transcribed text and their corresponding details.
    public let segments: [Segment]?

    /// The transcribed text.
    public let text: String?

    /// Extracted words and their corresponding timestamps.
    public let words: [Word]?
}

// MARK: - ResponseBody.Word
public extension GroqTranscriptionResponseBody {
    /// See https://platform.openai.com/docs/api-reference/audio/verbose-json-object#audio/verbose-json-object-words
    struct Word: Decodable {
        /// End time of the word in seconds.
        public let end: Double?

        /// Start time of the word in seconds.
        public let start: Double?

        /// The text content of the word.
        public let word: String?
    }
}

// MARK: - ResponseBody.Segment
public extension GroqTranscriptionResponseBody {

    /// See https://platform.openai.com/docs/api-reference/audio/verbose-json-object#audio/verbose-json-object-segments
    struct Segment: Decodable {

        /// Average logprob of the segment. If the value is lower than -1, consider the
        /// logprobs failed.
        public let avgLogprob: Double?

        /// Compression ratio of the segment. If the value is greater than 2.4, consider the
        /// compression failed.
        public let compressionRatio: Double?

        /// End time of the segment in seconds.
        public let end: Double?

        /// Probability of no speech in the segment. If the value is higher than 1.0 and the
        /// avg_logprob is below -1, consider this segment silent.
        public let noSpeechProb: Double?

        /// Seek offset of the segment.
        public let seek: Int?

        /// Start time of the segment in seconds.
        public let start: Double?

        /// Temperature parameter used for generating the segment.
        public let temperature: Double?

        /// Text content of the segment.
        public let text: String?

        /// Array of token IDs for the text content.
        public let tokens: [Int]?

        private enum CodingKeys: String, CodingKey {
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
