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
        return try await self.actorPollForWorkflowExecutionComplete(
            workflowID: workflowID,
            triggerID: triggerID,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
    }

    @NetworkActor
    private func actorPollForWorkflowExecutionComplete(
        workflowID: String,
        triggerID: String,
        numTries: Int,
        nsBetweenPollAttempts: UInt64
    ) async throws -> EachAIWorkflowExecutionResponseBody {
        try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        for _ in 0..<numTries {
            let response = try await self.actorGetWorkflowExecution(
                workflowID: workflowID,
                triggerID: triggerID
            )
            if response.status == "succeeded" {
                return response
            }
            print("Status is \(response.status)")
            try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        }
        throw EachAIError.reachedRetryLimit
    }

    /// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
    @NetworkActor
    private func actorGetWorkflowExecution(
        workflowID: String,
        triggerID: String
    ) async throws -> EachAIWorkflowExecutionResponseBody {
        let session = AIProxyURLSession.create()
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/api/v1/\(workflowID)/executions/\(triggerID)",
            body: nil,
            verb: .get
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

        return try EachAIWorkflowExecutionResponseBody.deserialize(from: data)
    }
}
