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

    /// One of the available TTS models: `tts-1` or `tts-1-hd`, default to `tts-1`
    /// Default to `tts-1`
    public let model: Model

    /// The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`.
    public let voice: Voice

    // Optional
    
    /// The format to audio in. Supported formats are `mp3`, `opus`, `aac`, `flac`, `wav`, and `pcm`.
    /// Default to `mp3`
    public let responseFormat: ResponseFormat?

    /// The speed of the generated audio. Select a value from 0.25 to 4.0.
    /// Default to `1.0`
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
    
    private enum CodingKeys: String, CodingKey {
        case input
        case model
        case voice
        case responseFormat = "response_format"
        case speed
    }
}

// MARK: - OpenAITextToSpeechRequestBody.Model
extension OpenAITextToSpeechRequestBody {
    public enum Model: String, Encodable {
        case tts1 = "tts-1"
        case tts1HD = "tts-1-hd"
    }
}

// MARK: - OpenAITextToSpeechRequestBody.ResponseFormat
extension OpenAITextToSpeechRequestBody {
    public enum ResponseFormat: String, Encodable {
        case mp3, opus, aac, flac, wav, pcm
    }
}

// MARK: - OpenAITextToSpeechRequestBody.Voice
extension OpenAITextToSpeechRequestBody {
    public enum Voice: String, Encodable {
        case alloy, echo, fable, onyx, nova, shimmer
    }
}
