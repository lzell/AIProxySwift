//
//  EachAIService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

public protocol EachAIService {
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
    func triggerWorkflow(
        workflowID: String,
        body: EachAITriggerWorkflowRequestBody
    ) async throws -> EachAITriggerWorkflowResponseBody

    /// You probably want to use `pollForWorkflowExecutionComplete`, defined below.
    /// This method gets the workflow execution response a single time, which may still be in the processing state.
    /// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
    func getWorkflowExecution(
        workflowID: String,
        triggerID: String
    ) async throws -> EachAIWorkflowExecutionResponseBody
}

extension EachAIService {
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
}
