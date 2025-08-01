//
//  EachAIDirectService.swift
//
//
//  Created by Lou Zell on 12/07/24.
//

import Foundation

open class EachAIDirectService: EachAIService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.eachAIDirectService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://flows.eachlabs.ai",
            path: "/api/v1/\(workflowID)/trigger",
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "X-API-Key": self.unprotectedAPIKey
            ]
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://flows.eachlabs.ai",
            path: "/api/v1/\(workflowID)/executions/\(triggerID)",
            body: nil,
            verb: .get,
            secondsToWait: 60,
            additionalHeaders: [
                "X-API-Key": self.unprotectedAPIKey
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Kicks off a single model run.
    /// You probably want `runModelAndPollForComplete` defined in the protocol extension below.
    public func runModel<T: Encodable>(
        body: EachAIPredictionRequestBody<T>
    ) async throws -> EachAIPredictionResponseBody {
        // request.addValue("api.eachlabs.ai", forHTTPHeaderField: "aiproxy-proxy-base-url")

        fatalError()
    }
}
