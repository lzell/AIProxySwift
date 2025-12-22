//
//  OpenAIApplyPatch.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Operations supplied to the `apply_patch` tool.
public enum OpenAIApplyPatchOperation: Encodable, Sendable {
    case createFile(OpenAIApplyPatchCreateFile)
    case deleteFile(OpenAIApplyPatchDeleteFile)
    case updateFile(OpenAIApplyPatchUpdateFile)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .createFile(let operation):
            try operation.encode(to: encoder)
        case .deleteFile(let operation):
            try operation.encode(to: encoder)
        case .updateFile(let operation):
            try operation.encode(to: encoder)
        }
    }
}
