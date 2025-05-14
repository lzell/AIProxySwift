//
//  ElevenLabsService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

public protocol ElevenLabsService {
    /// Converts text to speech with a request to `/v1/text-to-speech/<voice-id>`
    ///
    /// - Parameters:
    ///
    ///   - voiceID: The Voice ID to be used, you can use https://api.elevenlabs.io/v1/voices to list all the
    ///              available voices.
    ///
    ///   - body: The request body to send to ElevenLabs. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/text-to-speech/convert#request
    ///
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///
    /// - Returns: Returns audio/mpeg data
    func ttsRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> Data

    /// Converts speech to speech with a request to `/v1/speech-to-speech/<voice-id>`
    ///
    /// - Parameters:
    ///
    ///   - voiceID: The Voice ID to be used, you can use https://api.elevenlabs.io/v1/voices to list all the
    ///              available voices.
    ///
    ///   - body: The request body to send to ElevenLabs. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/speech-to-speech/convert#request
    ///
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///
    /// - Returns: Returns audio/mpeg data
    func speechToSpeechRequest(
        voiceID: String,
        body: ElevenLabsSpeechToSpeechRequestBody,
        secondsToWait: UInt
    ) async throws -> Data

    /// Converts text to speech with a request to `/v1/speech-to-text`
    ///
    /// - Parameters:
    ///
    ///   - body: The request body to send to ElevenLabs. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/speech-to-text/convert#request
    ///
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///
    /// - Returns: The speech to text response body
    func speechToTextRequest(
        body: ElevenLabsSpeechToTextRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsSpeechToTextResponseBody
}
