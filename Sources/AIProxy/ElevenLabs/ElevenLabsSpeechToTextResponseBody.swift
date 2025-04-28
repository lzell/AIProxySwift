//
//  ElevenLabsSpeechToTextResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 4/21/25.
//

import Foundation

/// https://elevenlabs.io/docs/api-reference/speech-to-text/convert#response
public struct ElevenLabsSpeechToTextResponseBody: Decodable {

    /// The detected language code (e.g. ‘eng’ for English).
    public let languageCode: String?

    /// The confidence score of the language detection (0 to 1).
    public let languageProbability: Double?

    /// The raw text of the transcription.
    public let text: String?

    /// List of words with their timing information.
    public let words: [Word]?

    /// Requested additional formats of the transcript.
    public let additionalFormats: [AdditionalFormat]?

    private enum CodingKeys: String, CodingKey {
        case languageCode = "language_code"
        case languageProbability = "language_probability"
        case text
        case words
        case additionalFormats = "additional_formats"
    }
}

extension ElevenLabsSpeechToTextResponseBody {
    public struct Word: Decodable {
        /// The word or sound that was transcribed.
        public let text: String

        /// The type of the word or sound. `audioEvent` is used for non-word sounds like laughter or footsteps.
        public let type: WordType?

        /// The start time of the word or sound in seconds.
        public let start: Double?

        /// The end time of the word or sound in seconds.
        public let end: Double?

        /// Unique identifier for the speaker of this word.
        public let speakerID: Double?

        /// The characters that make up the word and their timing information.
        public let characters: [Character]?

        private enum CodingKeys: String, CodingKey {
            case text
            case type
            case start
            case end
            case speakerID = "speaker_id"
            case characters
        }
    }

    public struct AdditionalFormat: Decodable {
        /// The requested format.
        public let requestedFormat: String

        /// The file extension of the additional format.
        public let fileExtension: String

        /// The content type of the additional format.
        public let contentType: String

        /// Whether the content is base64 encoded.
        public let isBase64Encoded: Bool

        /// The content of the additional format.
        public let content: String?

        private enum CodingKeys: String, CodingKey {
            case requestedFormat = "requested_format"
            case fileExtension = "file_extension"
            case contentType = "content_type"
            case isBase64Encoded = "is_base64_encoded"
            case content
        }
    }
}

extension ElevenLabsSpeechToTextResponseBody.Word {
    public struct Character: Decodable {
        /// The character that was transcribed.
        public let text: String

        /// The start time of the character in seconds.
        public let start: Double?

        /// The end time of the character in seconds.
        public let end: Double?
    }

    public enum WordType: String, Decodable {
        case word
        case spacing
        case audioEvent = "audio_event"
    }
}
