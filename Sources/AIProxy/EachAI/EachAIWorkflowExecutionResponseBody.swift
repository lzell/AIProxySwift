//
//  EachAIWorkflowExecutionResponseBody.swift
//
//
//  Created by Lou Zell on 12/8/24.
//

import Foundation

/// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
nonisolated public struct EachAIWorkflowExecutionResponseBody: Decodable, Sendable {
    public let averagePercent: Double?
    public let createdAt: String?
    public let deletedAt: String?
    public let endedAt: String?
    public let executionId: String?
    public let flowId: String?
    public let flowName: String?
    public let organizationId: String?
    public let output: String?
    public let outputJson: String?
    public let sourceIpAddress: String?
    public let startedAt: String?
    public let status: String?
    public let stepResults: [StepResult]?
    public let updatedAt: String?
    
    public init(averagePercent: Double?, createdAt: String?, deletedAt: String?, endedAt: String?, executionId: String?, flowId: String?, flowName: String?, organizationId: String?, output: String?, outputJson: String?, sourceIpAddress: String?, startedAt: String?, status: String?, stepResults: [StepResult]?, updatedAt: String?) {
        self.averagePercent = averagePercent
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.endedAt = endedAt
        self.executionId = executionId
        self.flowId = flowId
        self.flowName = flowName
        self.organizationId = organizationId
        self.output = output
        self.outputJson = outputJson
        self.sourceIpAddress = sourceIpAddress
        self.startedAt = startedAt
        self.status = status
        self.stepResults = stepResults
        self.updatedAt = updatedAt
    }

    private enum CodingKeys: String, CodingKey {
        case averagePercent = "average_percent"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case endedAt = "ended_at"
        case executionId = "execution_id"
        case flowId = "flow_id"
        case flowName = "flow_name"
        case organizationId = "organization_id"
        case output
        case outputJson = "output_json"
        case sourceIpAddress = "source_ip_address"
        case startedAt = "started_at"
        case status
        case stepResults = "step_results"
        case updatedAt = "updated_at"
    }
}

// MARK: - ResponseBody.StepResult
extension EachAIWorkflowExecutionResponseBody {
    nonisolated public struct StepResult: Decodable, Sendable {
        public let endedAt: String?
        public let input: String?
        public let model: String?
        public let output: String?
        public let outputJson: String?
        public let startedAt: String?
        public let status: String?
        public let stepId: String?
        public let stepName: String?
        public let version: String?
        
        public init(endedAt: String?, input: String?, model: String?, output: String?, outputJson: String?, startedAt: String?, status: String?, stepId: String?, stepName: String?, version: String?) {
            self.endedAt = endedAt
            self.input = input
            self.model = model
            self.output = output
            self.outputJson = outputJson
            self.startedAt = startedAt
            self.status = status
            self.stepId = stepId
            self.stepName = stepName
            self.version = version
        }

        private enum CodingKeys: String, CodingKey {
            case endedAt = "ended_at"
            case input
            case model
            case output
            case outputJson = "output_json"
            case startedAt = "started_at"
            case status
            case stepId = "step_id"
            case stepName = "step_name"
            case version
        }
    }
}

