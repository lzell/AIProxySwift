//
//  AnthropicToolChoice.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

import Foundation

/// How the model should use the provided tools.
///
/// The model can use a specific tool, any available tool, decide by itself, or not use tools at all.
nonisolated public enum AnthropicToolChoice: Encodable, Sendable {
    /// The model will automatically decide whether to use tools.
    case auto(disableParallelToolUse: Bool? = nil)

    /// The model will use any available tools.
    case any(disableParallelToolUse: Bool? = nil)

    /// The model will use the specified tool.
    case tool(name: String, disableParallelToolUse: Bool? = nil)

    /// The model will not be allowed to use tools.
    case none

    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case disableParallelToolUse = "disable_parallel_tool_use"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .auto(let disableParallelToolUse):
            try container.encode("auto", forKey: .type)
            try container.encodeIfPresent(disableParallelToolUse, forKey: .disableParallelToolUse)
        case .any(let disableParallelToolUse):
            try container.encode("any", forKey: .type)
            try container.encodeIfPresent(disableParallelToolUse, forKey: .disableParallelToolUse)
        case .tool(let name, let disableParallelToolUse):
            try container.encode("tool", forKey: .type)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(disableParallelToolUse, forKey: .disableParallelToolUse)
        case .none:
            try container.encode("none", forKey: .type)
        }
    }
}
