//
//  RemoteLoggerService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/31/25.
//

@AIProxyActor final class RemoteLoggerService: ProxiedService, Sendable {

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

    /// Logs a breadcrumb as fire-and-forget.
    /// There are no smarts built into this.
    /// If the message can't reach the destination, it is not retried.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy
    public func logBreadcrumb(
        context: String,
        errorMessage: String? = nil
    ) async {
        if let request = try? await AIProxyURLRequest.create(
            partialKey: self.publishableKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/breadcrumb",
            body: try Payload(
                breadcrumbContext: context,
                errorMessage: errorMessage
            ).serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        ) {
            _ = try? await BackgroundNetworker.makeRequestAndWaitForData(
                self.urlSession,
                request
            )
        }
    }
}

extension RemoteLoggerService {
    nonisolated fileprivate struct Payload: Encodable {
        let breadcrumbContext: String
        let errorMessage: String?
    }
}
