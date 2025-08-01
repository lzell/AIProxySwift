//
//  EachAIService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

open class EachAIService {
    private let requestBuilder: OpenAIRequestBuilder
    private let serviceNetworker: ServiceMixin

    /// This designated initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.eachAIService` or `AIProxy.directEachAIService` defined in AIProxy.swift.
    init(
        requestBuilder: OpenAIRequestBuilder,
        serviceNetworker: ServiceMixin
    ) {
        self.requestBuilder = requestBuilder
        self.serviceNetworker = serviceNetworker
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
        body: EachAITriggerWorkflowRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> EachAITriggerWorkflowResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: "/api/v1/\(workflowID)/trigger",
            body: body,
            secondsToWait: 60,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// You probably want to use `pollForWorkflowExecutionComplete`, defined below.
    /// This method gets the workflow execution response a single time, which may still be in the processing state.
    /// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
    public func getWorkflowExecution(
        workflowID: String,
        triggerID: String,
        additionalHeaders: [String: String] = [:]
    ) async throws -> EachAIWorkflowExecutionResponseBody {
        let request = try await self.requestBuilder.plainGET(
            path: "/api/v1/\(workflowID)/executions/\(triggerID)",
            secondsToWait: 60,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Polls for the completion of a workflow. By default, the time between polls is 10 seconds.
    /// If you have a workflow that completes quickly, consider dropping `secondsBetweenPollingAttempts`
    ///
    /// - Parameters:
    ///   - workflowID: Workflow ID
    ///
    ///   - triggerID: Trigger ID. This is returned from the `triggerWorkflow` call
    ///
    ///   - pollAttempts: Number of polling attempts to make before raising EachAIError.reachedRetryLimit
    ///
    ///   - secondsBetweenPollAttempts: Number of seconds between polls. Choose this value such
    ///   that `pollAttempts * secondsBetweenPollAttempts` is the total amount of time you want
    ///   to wait for your workflow to complete.
    ///
    /// - Returns: A workflow execution response with `status` set to `succeeded` and the
    ///            `output` set to the workflow execution result.
    public func pollForWorkflowExecutionComplete(
        workflowID: String,
        triggerID: String,
        pollAttempts: Int = 60,
        secondsBetweenPollAttempts: UInt64 = 10
    ) async throws -> EachAIWorkflowExecutionResponseBody {
        try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getWorkflowExecution(
                workflowID: workflowID,
                triggerID: triggerID
            )
            if response.status == "succeeded" {
                return response
            }
            try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        }
        throw EachAIError.reachedRetryLimit
    }

    /// Runs a model on EachAI.
    /// This method is intended for use with polling. We create the prediction here, and then use `pollForPredictionComplete`
    /// to periodically poll for the model run results.
    /// - Parameter body: The request body to send to `/v1/prediction/`
    /// - Returns: A prediction. Use the `predictionID` to continue polling for the prediction result
    public func createPrediction<T: Encodable>(
        body: EachAICreatePredictionRequestBody<T>
    ) async throws -> EachAICreatePredictionResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: "/v1/prediction/",  // The trailing slash is required
            body: body,
            secondsToWait: 60,
            additionalHeaders: [:],
            baseURLOverride: "https://api.eachlabs.ai"
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    public func pollForPredictionComplete(
        predictionID: String,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> EachAIPrediction {
        try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getPrediction(
                predictionID: predictionID
            )
            if response.status == "success" {
                return response
            }
            try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        }
        throw EachAIError.reachedRetryLimit
    }

    public func getPrediction(
        predictionID: String
    ) async throws -> EachAIPrediction {
        let request = try await self.requestBuilder.plainGET(
            path: "/v1/prediction/\(predictionID)",
            secondsToWait: 60,
            additionalHeaders: [:],
            baseURLOverride: "https://api.eachlabs.ai"
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }
}
