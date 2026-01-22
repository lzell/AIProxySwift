//
//  OpenAILocalShellCallAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-local_shell_call-action
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-local_shell_call-action

/// Execute a shell command on the server.
nonisolated public struct OpenAILocalShellToolCallAction: Codable, Sendable {
    /// The command to run.
    public let command: [String]

    /// Environment variables to set for the command.
    public let env: [String: String]

    /// The type of the local shell action. Always `exec`.
    public let type = "exec"

    /// Optional timeout in milliseconds for the command.
    public let timeoutMs: Int?

    /// Optional user to run the command as.
    public let user: String?

    /// Optional working directory to run the command in.
    public let workingDirectory: String?

    /// Creates a new local shell exec action.
    /// - Parameters:
    ///   - command: The command to run.
    ///   - env: Environment variables to set for the command.
    ///   - timeoutMs: Optional timeout in milliseconds for the command.
    ///   - user: Optional user to run the command as.
    ///   - workingDirectory: Optional working directory to run the command in.
    public init(
        command: [String],
        env: [String: String],
        timeoutMs: Int? = nil,
        user: String? = nil,
        workingDirectory: String? = nil
    ) {
        self.command = command
        self.env = env
        self.timeoutMs = timeoutMs
        self.user = user
        self.workingDirectory = workingDirectory
    }

    private enum CodingKeys: String, CodingKey {
        case command
        case env
        case type
        case timeoutMs = "timeout_ms"
        case user
        case workingDirectory = "working_directory"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(command, forKey: .command)
        try container.encode(env, forKey: .env)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(timeoutMs, forKey: .timeoutMs)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(workingDirectory, forKey: .workingDirectory)
    }
}
