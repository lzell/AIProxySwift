//
//  OpenAIApplyPatchDeleteFile.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Instruction for deleting an existing file via the `apply_patch` tool.
nonisolated public struct OpenAIApplyPatchDeleteFile: Codable, Sendable {
    /// Path of the file to delete relative to the workspace root.
    public let path: String

    /// The operation type. Always `delete_file`.
    public let type = "delete_file"

    /// Creates a new apply patch delete file operation parameter.
    /// - Parameters:
    ///   - path: Path of the file to delete relative to the workspace root.
    public init(path: String) {
        self.path = path
    }

    private enum CodingKeys: String, CodingKey {
        case path
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
    }
}
