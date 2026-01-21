//
//  OpenAICodeInterpreterOutputLogs.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// The logs output from the code interpreter.
nonisolated public struct OpenAICodeInterpreterOutputLogs: Codable, Sendable {
    /// The logs output from the code interpreter.
    public let logs: String
    
    /// The type of the output. Always `logs`.
    public let type = "logs"
    
    /// Creates a new code interpreter output logs.
    /// - Parameters:
    ///   - logs: The logs output from the code interpreter.
    public init(logs: String) {
        self.logs = logs
    }
    
    private enum CodingKeys: String, CodingKey {
        case logs
        case type
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logs, forKey: .logs)
        try container.encode(type, forKey: .type)
    }
}
