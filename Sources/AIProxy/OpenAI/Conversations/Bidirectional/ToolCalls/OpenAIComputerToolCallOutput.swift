//
//  OpenAIComputerToolCallOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: ComputerCallOutputItemParam, version 2.3.0, line 65717
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call_output

/// The output of a computer tool call.
nonisolated public struct OpenAIComputerToolCallOutput: Codable, Sendable {
    /// The ID of the computer tool call that produced the output.
    public let callID: String

    /// The ID of the computer tool call output.
    public let id: String

    /// The output of the computer tool call.
    public let output: OpenAIComputerScreenshot

    /// The type of the computer tool call output. Always `computer_call_output`.
    public let type = "computer_call_output"

    /// The safety checks reported by the API that have been acknowledged by the developer.
    public let acknowledgedSafetyChecks: [OpenAIComputerSafetyCheck]?

    /// The status of the message input.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when input items are returned via API.
    public let status: Status?

    /// Creates a new computer tool call output item parameter.
    /// - Parameters:
    ///   - callID: The ID of the computer tool call that produced the output.
    ///   - output: The output of the computer tool call.
    ///   - acknowledgedSafetyChecks: The safety checks reported by the API that have been acknowledged by the developer.
    ///   - id: The ID of the computer tool call output.
    ///   - status: The status of the message input.
    public init(
        callID: String,
        id: String,
        output: OpenAIComputerScreenshot,
        acknowledgedSafetyChecks: [OpenAIComputerSafetyCheck]? = nil,
        status: Status? = nil
    ) {
        self.callID = callID
        self.output = output
        self.acknowledgedSafetyChecks = acknowledgedSafetyChecks
        self.id = id
        self.status = status
    }

    private enum CodingKeys: String, CodingKey {
        case callID = "call_id"
        case output
        case type
        case acknowledgedSafetyChecks = "acknowledged_safety_checks"
        case id
        case status
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(callID, forKey: .callID)
        try container.encode(output, forKey: .output)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(acknowledgedSafetyChecks, forKey: .acknowledgedSafetyChecks)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(status, forKey: .status)
    }
}

extension OpenAIComputerToolCallOutput {
    nonisolated public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
    }
}
