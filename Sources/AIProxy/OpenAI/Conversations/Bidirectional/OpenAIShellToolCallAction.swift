//
//  OpenAIShellToolCallAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Commands and limits describing how to run the shell tool call.
nonisolated public struct OpenAIShellToolCallAction: Codable, Sendable {
    /// Ordered shell commands for the execution environment to run.
    public let commands: [String]

    /// Maximum number of UTF-8 characters to capture from combined stdout and stderr output.
    public let maxOutputLength: Int?

    /// Maximum wall-clock time in milliseconds to allow the shell commands to run.
    public let timeoutMs: Int?

    /// Creates a new shell action parameter.
    /// - Parameters:
    ///   - commands: Ordered shell commands for the execution environment to run.
    ///   - maxOutputLength: Maximum number of UTF-8 characters to capture from combined stdout and stderr output.
    ///   - timeoutMs: Maximum wall-clock time in milliseconds to allow the shell commands to run.
    public init(
        commands: [String],
        maxOutputLength: Int? = nil,
        timeoutMs: Int? = nil
    ) {
        self.commands = commands
        self.maxOutputLength = maxOutputLength
        self.timeoutMs = timeoutMs
    }

    private enum CodingKeys: String, CodingKey {
        case commands
        case maxOutputLength = "max_output_length"
        case timeoutMs = "timeout_ms"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commands, forKey: .commands)
        try container.encodeIfPresent(maxOutputLength, forKey: .maxOutputLength)
        try container.encodeIfPresent(timeoutMs, forKey: .timeoutMs)
    }
}
