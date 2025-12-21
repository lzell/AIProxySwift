//
//  OpenAIItem.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// Content item used to generate a response.
nonisolated public enum OpenAIItem: Sendable {
    case inputMessage(OpenAIInputMessage)
    case outputMessage(OpenAIOutputMessage)



}

// - $ref: '#/components/schemas/InputMessage'
// - $ref: '#/components/schemas/OutputMessage'
// - $ref: '#/components/schemas/FileSearchToolCall'
// - $ref: '#/components/schemas/ComputerToolCall'
// - $ref: '#/components/schemas/ComputerCallOutputItemParam'
// - $ref: '#/components/schemas/WebSearchToolCall'
// - $ref: '#/components/schemas/FunctionToolCall'
// - $ref: '#/components/schemas/FunctionCallOutputItemParam'
// - $ref: '#/components/schemas/ReasoningItem'
// - $ref: '#/components/schemas/CompactionSummaryItemParam'
// - $ref: '#/components/schemas/ImageGenToolCall'
// - $ref: '#/components/schemas/CodeInterpreterToolCall'
// - $ref: '#/components/schemas/LocalShellToolCall'
// - $ref: '#/components/schemas/LocalShellToolCallOutput'
// - $ref: '#/components/schemas/FunctionShellCallItemParam'
// - $ref: '#/components/schemas/FunctionShellCallOutputItemParam'
// - $ref: '#/components/schemas/ApplyPatchToolCallItemParam'
// - $ref: '#/components/schemas/ApplyPatchToolCallOutputItemParam'
// - $ref: '#/components/schemas/MCPListTools'
// - $ref: '#/components/schemas/MCPApprovalRequest'
// - $ref: '#/components/schemas/MCPApprovalResponse'
// - $ref: '#/components/schemas/MCPToolCall'
// - $ref: '#/components/schemas/CustomToolCallOutput'
// - $ref: '#/components/schemas/CustomToolCall'

