//
//  OpenAIApplyPatch.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Operations supplied to the `apply_patch` tool.
public enum OpenAIApplyPatchOperation: Codable, Sendable {
    case createFile(OpenAIApplyPatchCreateFile)
    case deleteFile(OpenAIApplyPatchDeleteFile)
    case updateFile(OpenAIApplyPatchUpdateFile)
    case futureProof

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .createFile(let operation):
            try operation.encode(to: encoder)
        case .deleteFile(let operation):
            try operation.encode(to: encoder)
        case .updateFile(let operation):
            try operation.encode(to: encoder)
        case .futureProof:
            break
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "create_file":
            self = .createFile(try OpenAIApplyPatchCreateFile(from: decoder))
        case "delete_file":
            self = .deleteFile(try OpenAIApplyPatchDeleteFile(from: decoder))
        case "update_file":
            self = .updateFile(try OpenAIApplyPatchUpdateFile(from: decoder))
        default:
            logIf(.error)?.error("Unknown apply patch operation type: \(type)")
            self = .futureProof
        }
    }

}
