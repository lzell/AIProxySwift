//
//  ElevenLabsDirectService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

open class ElevenLabsDirectService: ElevenLabsService, DirectService {

    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.elevenLabsDirectService` defined in AIProxy.swift
    internal init(unprotectedAPIKey: String) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Converts text to speech with a request to `/v1/text-to-speech/<voice-id>`
    ///
    /// - Parameters:
    ///
    ///   - voiceID: The Voice ID to be used, you can use https://api.elevenlabs.io/v1/voices to list all the
    ///              available voices.
    ///
    ///   - body: The request body to send to directly to ElevenLabs. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/text-to-speech
    ///
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///
    /// - Returns: Returns audio/mpeg data
    public func ttsRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> Data {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/text-to-speech/\(voiceID)",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return data
    }

    /// Converts speech to speech with a request to `/v1/speech-to-speech/<voice-id>`
    ///
    /// - Parameters:
    ///
    ///   - voiceID: The Voice ID to be used, you can use https://api.elevenlabs.io/v1/voices to list all the
    ///              available voices.
    ///
    ///   - body: The request body to send directly to ElevenLabs. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/speech-to-speech/convert
    ///
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///
    /// - Returns: Returns audio/mpeg data
    public func speechToSpeechRequest(
        voiceID: String,
        body: ElevenLabsSpeechToSpeechRequestBody,
        secondsToWait: UInt
    ) async throws -> Data {
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/speech-to-speech/\(voiceID)",
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return data
    }

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
    public func speechToTextRequest(
        body: ElevenLabsSpeechToTextRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsSpeechToTextResponseBody {
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/speech-to-text",
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
