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

    /// Initiates a non-streaming request to /v1/messages.
    ///
    /// - Parameters:
    ///
    ///   - voiceID: The Voice ID to be used, you can use https://api.elevenlabs.io/v1/voices to list all the
    ///              available voices.
    ///
    ///   - body: The request body to send to ElevenLabs through AIProxy. See this reference:
    ///           https://elevenlabs.io/docs/api-reference/text-to-speech
    ///
    /// - Returns: Returns audio/mpeg data
    public func ttsRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody
    ) async throws -> Data {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://api.elevenlabs.io",
            path: "/v1/text-to-speech/\(voiceID)",
            body: try body.serialize(),
            verb: .post,
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
}
