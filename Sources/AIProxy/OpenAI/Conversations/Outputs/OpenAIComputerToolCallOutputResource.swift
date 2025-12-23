//
//  OpenAIComputerToolCallOutputResource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ComputerToolCallOutputResource, version 2.3.0, line 2206

/// The output of a computer tool call.
nonisolated public struct OpenAIComputerToolCallOutputResource: Decodable, Sendable {
    /// The ID of the computer tool call that produced the output.
    public let callID: String

    /// The unique ID of the computer call tool output.
    public let id: String

    /// The screenshot output from the computer.
    public let output: OpenAIComputerScreenshotImageResource

    /// The type of the computer tool call output. Always `computer_call_output`.
    public let type: String

    /// The safety checks reported by the API that have been acknowledged by the developer.
    public let acknowledgedSafetyChecks: [OpenAIComputerSafetyCheckResource]?

    /// The status of the message input.
    ///
    /// One of `in_progress`, `completed`, or `incomplete`. Populated when input items are returned via API.
    public let status: OpenAIComputerToolCallStatus?

    private enum CodingKeys: String, CodingKey {
        case callID = "call_id"
        case id
        case output
        case type
        case acknowledgedSafetyChecks = "acknowledged_safety_checks"
        case status
    }
}

/// A computer screenshot image used with the computer use tool.
nonisolated public struct OpenAIComputerScreenshotImageResource: Decodable, Sendable {
    /// Specifies the event type. For a computer screenshot, this property is always set to `computer_screenshot`.
    public let type: String

    /// The identifier of an uploaded file that contains the screenshot.
    public let fileID: String?

    /// The URL of the screenshot image.
    public let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case fileID = "file_id"
        case imageURL = "image_url"
    }
}
