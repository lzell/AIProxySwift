//
//  EachAIWorkflowExecutionResponseBody.swift
//
//
//  Created by Lou Zell on 12/8/24.
//

import Foundation

/// https://docs.eachlabs.ai/api-reference/execution/get-flow-execution
public struct EachAIWorkflowExecutionResponseBody: Decodable {
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
    public struct StepResult: Decodable {
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

