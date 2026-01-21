//
//  OpenAICodeInterpreterOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public enum OpenAICodeInterpreterOutput: Codable, Sendable {
    /// The logs output from the code interpreter.
    case logs(OpenAICodeInterpreterOutputLogs)

    /// The image output from the code interpreter.
    case image(OpenAICodeInterpreterOutputImage)

    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "image":
            self = .image(try OpenAICodeInterpreterOutputImage(from: decoder))
        case "logs":
            self = .logs(try OpenAICodeInterpreterOutputLogs(from: decoder))
        default:
            logIf(.error)?.error("Unknown code interpreter output type: \(type)")
            self = .futureProof
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .logs(let output):
            try output.encode(to: encoder)
        case .image(let output):
            try output.encode(to: encoder)
        case .futureProof:
            break
        }
    }
}
