//
//  ElevenLabsService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

public protocol ElevenLabsService {
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
    func ttsRequest(
        voiceID: String,
        body: ElevenLabsTTSRequestBody
    ) async throws -> Data
}
