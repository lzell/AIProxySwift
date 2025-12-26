//
//  OpenAICodeInterpreterOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public enum OpenAICodeInterpreterOutput: Encodable, Decodable, Sendable {
    /// The logs output from the code interpreter.
    case logs(OpenAICodeInterpreterOutputLogs)

    /// The image output from the code interpreter.
    case image(OpenAICodeInterpreterOutputImage)

    case futureProof

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "image":
            self = .image(try OpenAICodeInterpreterOutputImageResource(from: decoder))
        case "logs":
            self = .logs(try OpenAICodeInterpreterOutputLogsResource(from: decoder))
        default:
            logIf(.error)?.error("Unknown code interpreter output type: \(type)")
            self = .futureProof
        }
    }
}
