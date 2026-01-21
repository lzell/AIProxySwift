//
//  OpenAIComputerToolCallSafetyCheck.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A  safety check for computer tool calls
/// https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-computer_tool_call-pending_safety_checks
nonisolated public struct OpenAIComputerSafetyCheck: Codable, Sendable {
    /// The ID of the safety check.
    public let id: String

    /// The type of the safety check.
    public let code: String?

    /// Details about the safety check.
    public let message: String?

    /// Creates a new computer call safety check parameter.
    /// - Parameters:
    ///   - id: The ID of the safety check.
    ///   - code: The type of the safety check.
    ///   - message: Details about the safety check.
    public init(
        id: String,
        code: String? = nil,
        message: String? = nil
    ) {
        self.id = id
        self.code = code
        self.message = message
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case code
        case message
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(message, forKey: .message)
    }
}
