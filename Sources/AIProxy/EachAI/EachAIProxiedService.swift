//
//  EachAIProxiedService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

open class EachAIProxiedService: EachAIService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
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
    ///   - workflowID: The workflow ID to trigger. You can find your ID in the EachAI dashboard.
    ///                 It will be included in the URL of the workflow that you are viewing, e.g.
    ///                 https://console.eachlabs.ai/flow/<your-id>
    ///
    ///   - body: The workflow request body. See this reference:
    ///           https://docs.eachlabs.ai/api-reference/flows/trigger-ai-workflow
    ///
    /// - Returns: A trigger workflow response, which contains a triggerID that you can use to
    ///           poll for the result.
    public func triggerWorkflow(
        workflowID: String,
        body: EachAITriggerWorkflowRequestBody
    ) async throws -> EachAITriggerWorkflowResponseBody {
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/\(workflowID)/trigger",
            body: try body.serialize(),
            verb: .post,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// You probably want to use `pollForWorkflowExecutionComplete`, defined as a protocol extension in EachAIService.swift.
    /// This method gets the workflow execution response a single time, which may still be in the processing state.
    /// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
    public func getWorkflowExecution(
        workflowID: String,
        triggerID: String
    ) async throws -> EachAIWorkflowExecutionResponseBody {
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/\(workflowID)/executions/\(triggerID)",
            body: nil,
            verb: .get
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}
