//
//  OpenAICodeInterpreterOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public enum OpenAICodeInterpreterOutput: Encodable, Sendable {
    /// The logs output from the code interpreter.
    case logs(OpenAICodeInterpreterOutputLogs)

    /// The image output from the code interpreter.
    case image(OpenAICodeInterpreterOutputImage)
}
