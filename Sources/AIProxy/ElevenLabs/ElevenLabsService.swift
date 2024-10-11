//
//  ElevenLabsService.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import Foundation

public final class ElevenLabsService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of ElevenLabsService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.elevenLabsService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
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
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.createHTTP(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/text-to-speech/\(voiceID)",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json"
        )

        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return data
    }
}
