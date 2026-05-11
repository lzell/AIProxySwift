//
//  ElevenLabsDirectService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

@AIProxyActor final class ElevenLabsDirectService: ElevenLabsService, DirectService, Sendable {

    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.elevenLabsDirectService` defined in AIProxy.swift
    nonisolated init(unprotectedAPIKey: String) {
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
        let response = try await self.ttsRequestWithMetadata(
            voiceID: voiceID,
            body: body,
            secondsToWait: secondsToWait
        )
        return response.body
    }

    public func ttsRequestWithMetadata(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsTTSResponse<Data> {
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
        let (data, httpResponse) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return ElevenLabsTTSResponse(body: data, headers: httpResponse.readableHeaders)
    }
    
    /// Converts text to speech with a request to `/v1/text-to-speech/<voice-id>/with-timestamps`
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
    /// - Returns: ElevenLabsTTSWithTimestampsResponseBody which includes timings for the returned audio.

    func ttsRequestWithTimestamps(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsTTSWithTimestampsResponseBody {
        let response = try await self.ttsRequestWithTimestampsAndMetadata(
            voiceID: voiceID,
            body: body,
            secondsToWait: secondsToWait
        )
        return response.body
    }

    func ttsRequestWithTimestampsAndMetadata(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsTTSResponse<ElevenLabsTTSWithTimestampsResponseBody> {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/text-to-speech/\(voiceID)/with-timestamps",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )
        
        return try await self.makeRequestAndDeserializeResponseWithMetadata(request)
    }

    /// Converts text to speech with a request to `/v1/text-to-speech/<voice-id>/stream?output_format=pcm_24000`
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
    /// - Returns: Returns an async stream that vends each time a chunk of audio is received over the network.
    ///            The stream consists of PCM16, int encoded, signed, little-endian audio at a 24 kHz sample rate.
    ///            The returned audio is playable by the `AudioController` class in this SDK.
    func streamingTTSRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncStream<Data> {
        let response = try await self.streamingTTSRequestWithMetadata(
            voiceID: voiceID,
            body: body,
            secondsToWait: secondsToWait
        )
        return response.stream
    }

    func streamingTTSRequestWithMetadata(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsTTSAudioStreamResponse {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/text-to-speech/\(voiceID)/stream?output_format=pcm_24000",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )
        let (stream, httpResponse) = try await BackgroundNetworker.makeRequestAndVendChunksWithResponse(self.urlSession, request)
        return ElevenLabsTTSAudioStreamResponse(headers: httpResponse.readableHeaders, stream: stream)
    }

    /// Converts text to speech with a request to `/v1/text-to-speech/<voice-id>/with-timestamps`
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
    /// - Returns: ElevenLabsTTSWithTimestampsResponseBody which includes timings for the returned audio. The
    ///            audio is always returned as PCM16, signed, little-endian data at a 24 kHz sample rate
    ///            (`output_format=pcm_24000`), and this output format is fixed in the request URL rather than
    ///            being configurable via a parameter.

    func streamingTTSWithTimestampsRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncThrowingStream<ElevenLabsTTSWithTimestampsResponseBody, Error>  {
        let response = try await self.streamingTTSWithTimestampsRequestWithMetadata(
            voiceID: voiceID,
            body: body,
            secondsToWait: secondsToWait
        )
        return response.stream
    }

    func streamingTTSWithTimestampsRequestWithMetadata(
        voiceID: String,
        body: ElevenLabsTTSRequestBody,
        secondsToWait: UInt
    ) async throws -> ElevenLabsTTSChunkStreamResponse<ElevenLabsTTSWithTimestampsResponseBody>  {
        let path = "/v1/text-to-speech/\(voiceID)/stream/with-timestamps?output_format=pcm_24000"

        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: path,
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "xi-api-key": self.unprotectedAPIKey
            ]
        )

        return try await self.makeRequestAndDeserializeNDJSONChunksWithMetadata(request)

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
