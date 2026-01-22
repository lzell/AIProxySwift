//
//  OpenAIComputerToolCall.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: ComputerToolCall, version 2.3.0, line 35839
// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call

/// A tool call to a computer use tool.
///
/// See the [computer use guide](https://platform.openai.com/docs/guides/tools-computer-use) for more information.
nonisolated public struct OpenAIComputerToolCall: Codable, Sendable {
    /// The action to perform on the computer.
    public let action: OpenAIComputerAction
    
    /// An identifier used when responding to the tool call with output.
    public let callID: String
    
    /// The unique ID of the computer call.
    public let id: String
    
    /// The pending safety checks for the computer call.
    public let pendingSafetyChecks: [OpenAIComputerSafetyCheck]
    
    /// The status of the item.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when items are returned via API.
    public let status: Status
    
    /// The type of the computer call. Always `computer_call`.
    public let type = "computer_call"
    
    /// Creates a new computer tool call.
    /// - Parameters:
    ///   - action: The action to perform on the computer.
    ///   - callID: An identifier used when responding to the tool call with output.
    ///   - id: The unique ID of the computer call.
    ///   - pendingSafetyChecks: The pending safety checks for the computer call.
    ///   - status: The status of the item.
    public init(
        action: OpenAIComputerAction,
        callID: String,
        id: String,
        pendingSafetyChecks: [OpenAIComputerSafetyCheck],
        status: Status
    ) {
        self.action = action
        self.callID = callID
        self.id = id
        self.pendingSafetyChecks = pendingSafetyChecks
        self.status = status
    }
    
    private enum CodingKeys: String, CodingKey {
        case action
        case callID = "call_id"
        case id
        case pendingSafetyChecks = "pending_safety_checks"
        case status
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action)
        try container.encode(callID, forKey: .callID)
        try container.encode(id, forKey: .id)
        try container.encode(pendingSafetyChecks, forKey: .pendingSafetyChecks)
        try container.encode(status, forKey: .status)
        try container.encode(type, forKey: .type)
    }
}

extension OpenAIComputerToolCall {
    /// The status of the computer tool call.
    public enum Status: String, Codable, Sendable {
        case inProgress = "in_progress"
        case completed
        case incomplete
    }
}
