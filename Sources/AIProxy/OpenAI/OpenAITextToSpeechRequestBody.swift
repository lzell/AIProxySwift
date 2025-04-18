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

    /// The text to generate audio for. The maximum length is 4096 characters.
    public let input: String

    /// One of the available TTS models: `tts-1` or `tts-1-hd`, default to `tts-1`
    /// Default to `tts-1`
    public let model: Model

    /// The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`.
    public let voice: Voice

    // MARK: Optional properties

    /// The format to audio in. Supported formats are `mp3`, `opus`, `aac`, `flac`, `wav`, and `pcm`.
    /// Default to `mp3`
    public let responseFormat: ResponseFormat?

    /// The speed of the generated audio. Select a value from 0.25 to 4.0.
    /// Default to `1.0`
    public let speed: Float?
    
    /// Control the voice of your generated audio with additional instructions. Does not work with `tts-1` or `tts-1-hd`.
    public let instructions: String?

    public init(
        input: String,
        model: Model = .tts1,
        voice: OpenAITextToSpeechRequestBody.Voice,
        responseFormat: OpenAITextToSpeechRequestBody.ResponseFormat? = .mp3,
        speed: Float? = 1.0,
        instructions: String? = nil
    ) {
        self.input = input
        self.model = model
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
        self.instructions = instructions
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case input
        case model
        case voice

        // Optional properties
        case responseFormat = "response_format"
        case speed
        case instructions

    }
}

// MARK: -
extension OpenAITextToSpeechRequestBody {
    public enum Model: String, Encodable {
        case tts1 = "tts-1"
        case tts1HD = "tts-1-hd"
        case gpt_4o_mini_tts = "gpt-4o-mini-tts"
    }
}

// MARK: -
extension OpenAITextToSpeechRequestBody {
    public enum ResponseFormat: String, Encodable {
        case aac
        case flac
        case mp3
        case pcm
        case opus
        case wav
    }
}

// MARK: -
extension OpenAITextToSpeechRequestBody {
    public enum Voice: String, Encodable {
        case alloy
        case ash
        case ballad
        case coral
        case echo
        case fable
        case onyx
        case nova
        case sage
        case shimmer
    }
}
