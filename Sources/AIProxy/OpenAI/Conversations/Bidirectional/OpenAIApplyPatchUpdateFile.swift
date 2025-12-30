//
//  OpenAIApplyPatchUpdateFile.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// Instruction for updating an existing file via the `apply_patch` tool.
nonisolated public struct OpenAIApplyPatchUpdateFile: Codable, Sendable {
    /// Unified diff content to apply to the existing file.
    public let diff: String

    /// Path of the file to update relative to the workspace root.
    public let path: String

    /// The operation type. Always `update_file`.
    public let type = "update_file"

    /// Creates a new apply patch update file operation parameter.
    /// - Parameters:
    ///   - diff: Unified diff content to apply to the existing file.
    ///   - path: Path of the file to update relative to the workspace root.
    public init(
        diff: String,
        path: String
    ) {
        self.diff = diff
        self.path = path
    }

    private enum CodingKeys: String, CodingKey {
        case diff
        case path
        case type
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(diff, forKey: .diff)
        try container.encode(path, forKey: .path)
        try container.encode(type, forKey: .type)
    }
}
