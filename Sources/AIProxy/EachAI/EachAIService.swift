//
//  EachAIService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

open class EachAIService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of EachAIService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.eachAIService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Runs a workflow on EachAI
    ///
    /// - Parameters:
    ///   - workflowID: The workflow ID to trigger. You can find your ID in the EachAI dashboard. It will be included in the URL of the workflow that you are viewing, e.g. `https://console.eachlabs.ai/flow/<your-id>`
    ///   - body: The workflow request body. See this reference:
    ///           https://docs.eachlabs.ai/api-reference/flows/trigger-ai-workflow
    /// - Returns: A trigger workflow response, which contains a triggerID that you can use to poll for the result.
    public func triggerWorkflow(
        workflowID: String,
        body: EachAITriggerWorkflowRequestBody
    ) async throws -> EachAITriggerWorkflowResponseBody {
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/\(workflowID)/trigger",
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

        return try EachAITriggerWorkflowResponseBody.deserialize(from: data)
    }

//    public func pollForExecutionComplete(
//        workflowID: String,
//        triggerID: String
//    ) async throws {
//        let session = AIProxyURLSession.create()
//        let request = try await AIProxyURLRequest.create(
//            partialKey: self.partialKey,
//            serviceURL: self.serviceURL,
//            clientID: self.clientID,
//            proxyPath: "/api/v1/\(workflowID)/trigger",
//            body: try body.serialize(),
//            verb: .post,
//            contentType: "application/json"
//        )
//
//        let (data, res) = try await session.data(for: request)
//        guard let httpResponse = res as? HTTPURLResponse else {
//            throw AIProxyError.assertion("Network response is not an http response")
//        }
//
//        if (httpResponse.statusCode > 299) {
//            throw AIProxyError.unsuccessfulRequest(
//                statusCode: httpResponse.statusCode,
//                responseBody: String(data: data, encoding: .utf8) ?? ""
//            )
//        }
//    }
}
