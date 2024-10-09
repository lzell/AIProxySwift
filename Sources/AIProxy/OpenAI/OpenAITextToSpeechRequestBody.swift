//
//  OpenAITextToSpeechRequestBody.swift
//
//
//  Created by Daniel Aditya Istyana on 10/9/24.
//


import Foundation

/// Docstrings from 
/// https://platform.openai.com/docs/api-reference/audio/createSpeech
public struct OpenAITextToSpeechRequestBody: Encodable {

    // Required
    /// The text to generate audio for. The maximum length is 4096 characters.
    public let input: String

    // Required
    /// One of the available TTS models: `tts-1` or `tts-1-hd`, default to `tts-1`
    public let model: Model

    // Required
    /// The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`.
    public let voice: Voice

    /// The format to audio in. Supported formats are `mp3`, `opus`, `aac`, `flac`, `wav`, and `pcm`.
    public let responseFormat: ResponseFormat?

    /// The speed of the generated audio. Select a value from 0.25 to 4.0. 1.0 is the default.
    public let speed: Float?

    public init(
        input: String,
        model: Model = .tts1,
        voice: OpenAITextToSpeechRequestBody.Voice,
        responseFormat: OpenAITextToSpeechRequestBody.ResponseFormat? = .mp3,
        speed: Float? = 1.0
    ) {
        self.input = input
        self.model = model
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
    }
}

// MARK: - OpenAITextToSpeechRequestBody.Model
public extension OpenAITextToSpeechRequestBody {
    enum Model: String, Encodable {
        case tts1 = "tts-1"
        case tts1HD = "tts-1-hd"
    }
}

// MARK: - OpenAITextToSpeechRequestBody.ResponseFormat
public extension OpenAITextToSpeechRequestBody {
    enum ResponseFormat: String, Encodable {
        case mp3, opus, aac, flac, wav, pcm
    }
}

// MARK: - OpenAITextToSpeechRequestBody.Voice
public extension OpenAITextToSpeechRequestBody {
    enum Voice: String, Encodable {
        case alloy, echo, fable, onyx, nova, shimmer
    }
}
