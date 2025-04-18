//
//  ElevenLabsTTSRequestBody.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import Foundation

/// Request body for a text-to-speech request to ElevenLabs.
/// https://elevenlabs.io/docs/api-reference/text-to-speech/convert
/// Note that `voiceID` is set on the path, not in the request body.
public struct ElevenLabsTTSRequestBody: Encodable {
    // Required
    public let text: String

    // Optional

    /// Language code (ISO 639-1) used to enforce a language for the model. Currently only
    /// Turbo v2.5 supports language enforcement. For other models, an error will be returned
    /// if language code is provided.
    public let languageCode: String?

    /// Identifier of the model that will be used, you can query them using GET /v1/models. The
    /// model needs to have support for text to speech, you can check this using the
    /// `can_do_text_to_speech` property.
    ///
    /// Defaults to `eleven_monolingual_v1`
    public let modelID: String?

    /// A list of request_id of the samples that were generated before this generation. Can be
    /// used to improve the flow of prosody when splitting up a large task into multiple
    /// requests. The results will be best when the same model is used across the generations.
    /// In case both next_text and next_request_ids is send, next_text will be ignored. A
    /// maximum of 3 request_ids can be send.
    public let nextRequestIDs: [String]?

    /// The text that comes after the text of the current request. Can be used to improve the
    /// flow of prosody when concatenating together multiple generations or to influence the
    /// prosody in the current generation.
    public let nextText: String?

    /// A list of request_id of the samples that were generated before this generation. Can be
    /// used to improve the flow of prosody when splitting up a large task into multiple
    /// requests. The results will be best when the same model is used across the generations.
    /// In case both previous_text and previous_request_ids is send, previous_text will be
    /// ignored. A maximum of 3 request_ids can be send.
    public let previousRequestIDs: [String]?

    /// The text that came before the text of the current request. Can be used to improve the
    /// flow of prosody when concatenating together multiple generations or to influence the
    /// prosody in the current generation.
    public let previousText: String?

    /// A list of pronunciation dictionary locators to be applied to the text. They will be
    /// applied in order. You may have up to 3 locators per request
    public let pronunciationDictionaryLocators: [PronunciationDictionaryLocator]?

    /// If specified, our system will make a best effort to sample deterministically, such that
    /// repeated requests with the same seed and parameters should return the same result.
    /// Determinism is not guaranteed.
    public let seed: Int?

    /// Voice settings overriding stored setttings for the given voice. They are applied only
    /// on the given request.
    public let voiceSettings: VoiceSettings?

    private enum CodingKeys: String, CodingKey {
        case text
        case languageCode = "language_code"
        case modelID = "model_id"
        case nextRequestIDs = "next_request_ids"
        case nextText = "next_text"
        case previousRequestIDs = "previous_request_ids"
        case previousText = "previous_text"
        case pronunciationDictionaryLocators = "pronunciation_dictionary_locators"
        case seed
        case voiceSettings = "voice_settings"
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        text: String,
        languageCode: String? = nil,
        modelID: String? = nil,
        nextRequestIDs: [String]? = nil,
        nextText: String? = nil,
        previousRequestIDs: [String]? = nil,
        previousText: String? = nil,
        pronunciationDictionaryLocators: [ElevenLabsTTSRequestBody.PronunciationDictionaryLocator]? = nil,
        seed: Int? = nil,
        voiceSettings: ElevenLabsTTSRequestBody.VoiceSettings? = nil
    ) {
        self.text = text
        self.languageCode = languageCode
        self.modelID = modelID
        self.nextRequestIDs = nextRequestIDs
        self.nextText = nextText
        self.previousRequestIDs = previousRequestIDs
        self.previousText = previousText
        self.pronunciationDictionaryLocators = pronunciationDictionaryLocators
        self.seed = seed
        self.voiceSettings = voiceSettings
    }
}

extension ElevenLabsTTSRequestBody {
    /// See this guide for details on pronunciation dictionaries:
    /// https://elevenlabs.io/docs/api-reference/how-to-use-pronunciation-dictionaries
    public struct PronunciationDictionaryLocator: Encodable {
        public let pronunciationDictionaryID: String
        public let versionID: String
        
        public init(
            pronunciationDictionaryID: String,
            versionID: String
        ) {
            self.pronunciationDictionaryID = pronunciationDictionaryID
            self.versionID = versionID
        }

        private enum CodingKeys: String, CodingKey {
            case pronunciationDictionaryID = "pronunciation_dictionary_id"
            case versionID = "version_id"
        }
    }
}

extension ElevenLabsTTSRequestBody {

    /// Docstrings copied from here:
    /// https://elevenlabs.io/docs/speech-synthesis/voice-settings
    public struct VoiceSettings: Encodable {

        /// The similarity value dictates how closely the AI should adhere to the original
        /// voice when attempting to replicate it. If the original audio is of poor quality and
        /// the similarity value is set too high, the AI may reproduce artifacts or background
        /// noise when trying to mimic the voice if those were present in the original
        /// recording.
        public let similarityBoost: Double

        /// The stability value determines how stable the voice is and the randomness between
        /// each generation. Lowering this value introduces a broader emotional range for the
        /// voice. Setting the value too low may result in odd performances that are overly
        /// random and cause the character to speak too quickly. On the other hand, setting it
        /// too high can lead to a monotonous voice with limited emotion.
        public let stability: Double

        /// This setting was introduced in newer models. The setting itself is quite
        /// self-explanatory – it boosts the similarity to the original speaker. However, using
        /// this setting requires a slightly higher computational load, which in turn increases
        /// latency. The differences introduced by this setting are generally rather subtle.
        public let speakerBoost: Bool?

        /// This setting was introduced in newer models. This setting attempts to amplify the
        /// style of the original speaker. It does consume additional computational resources
        /// and might increase latency if set to anything other than 0. It’s important to note
        /// that using this setting has shown to make the model slightly less stable, as it
        /// strives to emphasize and imitate the style of the original voice.
        ///
        /// In general, we recommend keeping this setting at 0 at all times.
        public let style: Double?
        
        public init(
            similarityBoost: Double,
            stability: Double,
            speakerBoost: Bool? = nil,
            style: Double? = nil
        ) {
            self.similarityBoost = similarityBoost
            self.stability = stability
            self.speakerBoost = speakerBoost
            self.style = style
        }

        private enum CodingKeys: String, CodingKey {
            case similarityBoost = "similarity_boost"
            case stability
            case speakerBoost = "speaker_boost"
            case style
        }
    }
}
