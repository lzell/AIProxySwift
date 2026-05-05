//
//  ElevenLabsTTSWithTimestampsResponseBody.swift
//
//
//  Created by Sean Langley on 1/18/26.
//

import Foundation

/// Response body for a text-to-speech stream with timestamps request to ElevenLabs.
/// https://elevenlabs.io/docs/api-reference/text-to-speech/stream-with-timestamps
/// Each chunk in the stream contains audio data and timing information.
nonisolated public struct ElevenLabsTTSWithTimestampsResponseBody:  Sendable, Decodable {

    /// Base64 encoded audio data
    public let audioBase64: String

    /// Timestamp information for each character in the original text
    public let alignment: CharacterAlignment?

    /// Timestamp information for each character in the normalized text
    public let normalizedAlignment: CharacterAlignment?

    public init(
        audioBase64: String,
        alignment: CharacterAlignment? = nil,
        normalizedAlignment: CharacterAlignment? = nil
    ) {
        self.audioBase64 = audioBase64
        self.alignment = alignment
        self.normalizedAlignment = normalizedAlignment
    }

    private enum CodingKeys: String, CodingKey {
        case audioBase64 = "audio_base64"
        case alignment
        case normalizedAlignment = "normalized_alignment"
    }
}

extension ElevenLabsTTSWithTimestampsResponseBody {
    /// Character alignment information with timing data
    nonisolated public struct CharacterAlignment: Decodable, Sendable {
        /// The characters in the text
        public let characters: [String]

        /// Start time in seconds for each character
        public let characterStartTimesSeconds: [Double]

        /// End time in seconds for each character
        public let characterEndTimesSeconds: [Double]

        public init(
            characters: [String],
            characterStartTimesSeconds: [Double],
            characterEndTimesSeconds: [Double]
        ) {
            self.characters = characters
            self.characterStartTimesSeconds = characterStartTimesSeconds
            self.characterEndTimesSeconds = characterEndTimesSeconds
        }

        private enum CodingKeys: String, CodingKey {
            case characters
            case characterStartTimesSeconds = "character_start_times_seconds"
            case characterEndTimesSeconds = "character_end_times_seconds"
        }
    }
}

extension ElevenLabsTTSWithTimestampsResponseBody {
    /// Decodes the base64 audio data into raw bytes
    /// - Returns: The decoded audio data, or nil if decoding fails
    public var audioData: Data? {
        Data(base64Encoded: audioBase64)
    }
}
