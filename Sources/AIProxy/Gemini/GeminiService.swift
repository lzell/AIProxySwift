//  AIProxy.swift
//  Created by Todd Hamilton on 10/14/24.

import Foundation

public final class GeminiService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of GeminiService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.geminiService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    public func generateContentRequest(
        body: GeminiGenerateContentRequestBody
    ) async throws -> GeminiGenerateContentResponseBody {
        var body = body
        let session = AIProxyURLSession.create()
        let proxyPath = "/v1beta/models/\(body.model):generateContent"

        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: proxyPath,
            body:  body.serialize(),
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

        return try GeminiGenerateContentResponseBody.deserialize(from: data)
    }

}
