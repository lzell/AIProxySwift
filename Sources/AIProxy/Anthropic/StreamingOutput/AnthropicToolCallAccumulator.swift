//
//  AnthropicToolCallAccumulator.swift
//  AIProxy
//
//  Created by Lou Zell on 12/13/25.
//

/// Use this type to help capture the name and arguments of streaming tool calls
nonisolated public struct AnthropicToolCallAccumulator {
    private var toolName: String?
    private var toolUseAccumulator: String = ""

    public init() {}

    /// Appends a streaming event and returns the completed tool call if one finished
    /// - Parameter event: The streaming event from Anthropic
    /// - Returns: A tuple of (toolName, toolInput) if a tool call completed, nil otherwise
    /// - Throws: If JSON parsing fails when a tool call completes
    public mutating func append(_ event: AnthropicStreamingEvent) throws -> (String, [String: Any])? {
        switch event {
        case .contentBlockStart(let start):
            if case .toolUseBlock(let block) = start.contentBlock {
                toolName = block.name
                toolUseAccumulator = ""
            }
            return nil

        case .contentBlockDelta(let deltaUnion):
            if case .inputJSONDelta(let jsonDelta) = deltaUnion.delta {
                logIf(.debug)?.debug("AIProxy: accumulating partial JSON from anthropic: \(jsonDelta.partialJSON)")
                toolUseAccumulator += jsonDelta.partialJSON
            }
            return nil

        case .contentBlockStop(_):
            if let name = toolName {
                let input = try [String: AIProxyJSONValue]
                    .deserialize(from: toolUseAccumulator)
                    .untypedDictionary
                toolName = nil
                toolUseAccumulator = ""
                return (name, input)
            }
            return nil

        default:
            return nil
        }
    }
}
