//
//  MistralService.swift
//
//
//  Created by Lou Zell on 11/24/24.
//

import Foundation

open class MistralService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of MistralService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.mistralService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Initiates a non-streaming chat completion request to Mistral
    ///
    /// - Parameters:
    ///   - body: The chat completion request body. See this reference:
    ///           https://docs.mistral.ai/api/#tag/chat/operation/chat_completion_v1_chat_completions_post
    /// - Returns: A ChatCompletionResponse.
    public func chatCompletionRequest(
        body: MistralChatCompletionRequestBody
    ) async throws -> MistralChatCompletionResponseBody {
        var body = body
        body.stream = false
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/chat/completions",
            body:  try body.serialize(),
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

        return try MistralChatCompletionResponseBody.deserialize(from: data)
    }
}
