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
    public let parameters: [Parameter]?
    public let sourceIpAddress: String?
    public let startedAt: String?
    public let status: String?
    public let stepResults: [StepResult]?
    public let updatedAt: String?

    public init(averagePercent: Double?, createdAt: String?, deletedAt: String?, endedAt: String?, executionId: String?, flowId: String?, flowName: String?, organizationId: String?, output: String?, outputJson: String?, parameters: [Parameter]?, sourceIpAddress: String?, startedAt: String?, status: String?, stepResults: [StepResult]?, updatedAt: String?) {
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
        self.parameters = parameters
        self.sourceIpAddress = sourceIpAddress
        self.startedAt = startedAt
        self.status = status
        self.stepResults = stepResults
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.averagePercent = try container.decodeIfPresent(Double.self, forKey: .averagePercent)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        self.endedAt = try container.decodeIfPresent(String.self, forKey: .endedAt)
        self.executionId = try container.decodeIfPresent(String.self, forKey: .executionId)
        self.flowId = try container.decodeIfPresent(String.self, forKey: .flowId)
        self.flowName = try container.decodeIfPresent(String.self, forKey: .flowName)
        self.organizationId = try container.decodeIfPresent(String.self, forKey: .organizationId)
        self.output = try container.decodeIfPresent(String.self, forKey: .output)
        self.outputJson = container.decodeStringOrArrayIfPresent(forKey: .outputJson)
        self.parameters = try container.decodeIfPresent([Parameter].self, forKey: .parameters)
        self.sourceIpAddress = try container.decodeIfPresent(String.self, forKey: .sourceIpAddress)
        self.startedAt = try container.decodeIfPresent(String.self, forKey: .startedAt)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.stepResults = try container.decodeIfPresent([StepResult].self, forKey: .stepResults)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
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
        case parameters
        case sourceIpAddress = "source_ip_address"
        case startedAt = "started_at"
        case status
        case stepResults = "step_results"
        case updatedAt = "updated_at"
    }
}

// MARK: - ResponseBody.Parameter
extension EachAIWorkflowExecutionResponseBody {
    nonisolated public struct Parameter: Decodable, Sendable {
        public let name: String?
        public let value: String?

        public init(name: String?, value: String?) {
            self.name = name
            self.value = value
        }
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

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.endedAt = try container.decodeIfPresent(String.self, forKey: .endedAt)
            self.input = try container.decodeIfPresent(String.self, forKey: .input)
            self.model = try container.decodeIfPresent(String.self, forKey: .model)
            self.outputJson = container.decodeStringOrArrayIfPresent(forKey: .outputJson)
            self.output = try container.decodeIfPresent(String.self, forKey: .output)
            self.startedAt = try container.decodeIfPresent(String.self, forKey: .startedAt)
            self.status = try container.decodeIfPresent(String.self, forKey: .status)
            self.stepId = try container.decodeIfPresent(String.self, forKey: .stepId)
            self.stepName = try container.decodeIfPresent(String.self, forKey: .stepName)
            self.version = try container.decodeIfPresent(String.self, forKey: .version)
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

// MARK: - KeyedDecodingContainer Extension
extension KeyedDecodingContainer {
    /// Decodes a value as either a String or [String], returning the first element if it's an array.
    ///
    /// This is needed because the EachAI API inconsistently returns `output_json` and `output` fields:
    /// sometimes as a string, sometimes as an array of strings. To prevent decoding failures,
    /// we attempt both formats and extract the first element when an array is returned.
    func decodeStringOrArrayIfPresent(forKey key: Key) -> String? {
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return stringValue
        } else if let arrayValue = try? decodeIfPresent([String].self, forKey: key) {
            return arrayValue.first
        } else {
            return nil
        }
    }
}
