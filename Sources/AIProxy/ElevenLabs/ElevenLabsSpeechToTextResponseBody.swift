//
//  ElevenLabsSpeechToTextResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 4/21/25.
//

import Foundation

/// https://elevenlabs.io/docs/api-reference/speech-to-text/convert#response
nonisolated public struct ElevenLabsSpeechToTextResponseBody: Decodable, Sendable {

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
    
    public init(languageCode: String?, languageProbability: Double?, text: String?, words: [Word]?, additionalFormats: [AdditionalFormat]?) {
        self.languageCode = languageCode
        self.languageProbability = languageProbability
        self.text = text
        self.words = words
        self.additionalFormats = additionalFormats
    }

    private enum CodingKeys: String, CodingKey {
        case languageCode = "language_code"
        case languageProbability = "language_probability"
        case text
        case words
        case additionalFormats = "additional_formats"
    }
}

extension ElevenLabsSpeechToTextResponseBody {
    nonisolated public struct Word: Decodable, Sendable {
        /// The word or sound that was transcribed.
        public let text: String

        /// The type of the word or sound. `audioEvent` is used for non-word sounds like laughter or footsteps.
        public let type: WordType?

        /// The start time of the word or sound in seconds.
        public let start: Double?

        /// The end time of the word or sound in seconds.
        public let end: Double?

        /// Unique identifier for the speaker of this word.
        public let speakerID: String?

        /// The characters that make up the word and their timing information.
        public let characters: [Character]?
        
        public init(text: String, type: WordType?, start: Double?, end: Double?, speakerID: String?, characters: [Character]?) {
            self.text = text
            self.type = type
            self.start = start
            self.end = end
            self.speakerID = speakerID
            self.characters = characters
        }

        private enum CodingKeys: String, CodingKey {
            case text
            case type
            case start
            case end
            case speakerID = "speaker_id"
            case characters
        }
    }

    nonisolated public struct AdditionalFormat: Decodable, Sendable {
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
        
        public init(requestedFormat: String, fileExtension: String, contentType: String, isBase64Encoded: Bool, content: String?) {
            self.requestedFormat = requestedFormat
            self.fileExtension = fileExtension
            self.contentType = contentType
            self.isBase64Encoded = isBase64Encoded
            self.content = content
        }

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
    nonisolated public struct Character: Decodable, Sendable {
        /// The character that was transcribed.
        public let text: String

        /// The start time of the character in seconds.
        public let start: Double?

        /// The end time of the character in seconds.
        public let end: Double?
        
        public init(text: String, start: Double?, end: Double?) {
            self.text = text
            self.start = start
            self.end = end
        }
    }

    nonisolated public enum WordType: String, Decodable, Sendable {
        case word
        case spacing
        case audioEvent = "audio_event"
    }
}
