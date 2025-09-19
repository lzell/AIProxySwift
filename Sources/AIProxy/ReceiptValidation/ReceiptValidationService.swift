//
//  ReceiptValidationService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/28/25.
//

@AIProxyActor final class ReceiptValidationService: ProxiedService, Sendable {

    public let publishableKey: String
    public let serviceURL: String
    public let clientID: String?

    public init(
        publishableKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) {
        self.publishableKey = publishableKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Makes a request to validate the app purchase
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy
    /// - Returns: The validation result
    public func validateReceipt(
        body: ReceiptValidationRequestBody
    ) async throws -> ReceiptValidationResponseBody {
        let request = try await AIProxyURLRequest.create(
            partialKey: self.publishableKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/validate",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
