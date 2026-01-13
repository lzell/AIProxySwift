//
//  OpenAIConversationsItem.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// A single item within a conversation.
///
/// The set of possible types are the same as the `output` type of a Response object.
/// See: https://platform.openai.com/docs/api-reference/responses/object#responses/object-output
nonisolated public enum OpenAIConversationsItem: Decodable, Sendable {
    case message(OpenAIConversationsMessage)
    case functionToolCall(OpenAIConversationsFunctionToolCall)
    case functionToolCallOutput(OpenAIConversationsFunctionToolCallOutput)
    case fileSearchToolCall(OpenAIConversationsFileSearchToolCall)
    case webSearchToolCall(OpenAIConversationsWebSearchToolCall)
    case imageGenToolCall(OpenAIConversationsImageGenToolCall)
    case computerToolCall(OpenAIConversationsComputerToolCall)
    case computerToolCallOutput(OpenAIConversationsComputerToolCallOutput)
    case reasoningItem(OpenAIConversationsReasoningItem)
    case codeInterpreterToolCall(OpenAIConversationsCodeInterpreterToolCall)
    case localShellToolCall(OpenAIConversationsLocalShellToolCall)
    case localShellToolCallOutput(OpenAIConversationsLocalShellToolCallOutput)
    case functionShellCall(OpenAIConversationsFunctionShellCall)
    case functionShellCallOutput(OpenAIConversationsFunctionShellCallOutput)
    case applyPatchToolCall(OpenAIConversationsApplyPatchToolCall)
    case applyPatchToolCallOutput(OpenAIConversationsApplyPatchToolCallOutput)
    case mcpListTools(OpenAIConversationsMCPListTools)
    case mcpApprovalRequest(OpenAIConversationsMCPApprovalRequest)
    case mcpApprovalResponse(OpenAIConversationsMCPApprovalResponse)
    case mcpToolCall(OpenAIConversationsMCPToolCall)
    case customToolCall(OpenAIConversationsCustomToolCall)
    case customToolCallOutput(OpenAIConversationsCustomToolCallOutput)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "message":
            self = .message(try OpenAIConversationsMessage(from: decoder))
        case "function_call":
            self = .functionToolCall(try OpenAIConversationsFunctionToolCall(from: decoder))
        case "function_call_output":
            self = .functionToolCallOutput(try OpenAIConversationsFunctionToolCallOutput(from: decoder))
        case "file_search_call":
            self = .fileSearchToolCall(try OpenAIConversationsFileSearchToolCall(from: decoder))
        case "web_search_call":
            self = .webSearchToolCall(try OpenAIConversationsWebSearchToolCall(from: decoder))
        case "image_generation_call":
            self = .imageGenToolCall(try OpenAIConversationsImageGenToolCall(from: decoder))
        case "computer_call":
            self = .computerToolCall(try OpenAIConversationsComputerToolCall(from: decoder))
        case "computer_call_output":
            self = .computerToolCallOutput(try OpenAIConversationsComputerToolCallOutput(from: decoder))
        case "reasoning":
            self = .reasoningItem(try OpenAIConversationsReasoningItem(from: decoder))
        case "code_interpreter_call":
            self = .codeInterpreterToolCall(try OpenAIConversationsCodeInterpreterToolCall(from: decoder))
        case "local_shell_call":
            self = .localShellToolCall(try OpenAIConversationsLocalShellToolCall(from: decoder))
        case "local_shell_call_output":
            self = .localShellToolCallOutput(try OpenAIConversationsLocalShellToolCallOutput(from: decoder))
        case "function_shell_call":
            self = .functionShellCall(try OpenAIConversationsFunctionShellCall(from: decoder))
        case "function_shell_call_output":
            self = .functionShellCallOutput(try OpenAIConversationsFunctionShellCallOutput(from: decoder))
        case "apply_patch_call":
            self = .applyPatchToolCall(try OpenAIConversationsApplyPatchToolCall(from: decoder))
        case "apply_patch_call_output":
            self = .applyPatchToolCallOutput(try OpenAIConversationsApplyPatchToolCallOutput(from: decoder))
        case "mcp_list_tools":
            self = .mcpListTools(try OpenAIConversationsMCPListTools(from: decoder))
        case "mcp_approval_request":
            self = .mcpApprovalRequest(try OpenAIConversationsMCPApprovalRequest(from: decoder))
        case "mcp_approval_response":
            self = .mcpApprovalResponse(try OpenAIConversationsMCPApprovalResponse(from: decoder))
        case "mcp_call":
            self = .mcpToolCall(try OpenAIConversationsMCPToolCall(from: decoder))
        default:
            // For custom tool calls and unknown types, try to decode as custom
            if type.hasSuffix("_call_output") {
                self = .customToolCallOutput(try OpenAIConversationsCustomToolCallOutput(from: decoder))
            } else if type.hasSuffix("_call") {
                self = .customToolCall(try OpenAIConversationsCustomToolCall(from: decoder))
            } else {
                self = .futureProof
            }
        }
    }
}
