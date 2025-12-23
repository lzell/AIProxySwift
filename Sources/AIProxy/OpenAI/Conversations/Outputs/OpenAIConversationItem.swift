//
//  OpenAIConversationItem.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ConversationItem, version 2.3.0, line 2401

/// A single item within a conversation.
///
/// The set of possible types are the same as the `output` type of a
/// [Response object](https://platform.openai.com/docs/api-reference/responses/object#responses/object-output).
nonisolated public enum OpenAIConversationItem: Decodable, Sendable {
    case applyPatchToolCall(OpenAIApplyPatchToolCallResource)
    case applyPatchToolCallOutput(OpenAIApplyPatchToolCallOutputResource)
    case codeInterpreterToolCall(OpenAICodeInterpreterToolCallResource)
    case computerToolCall(OpenAIComputerToolCallResource)
    case computerToolCallOutput(OpenAIComputerToolCallOutputResource)
    case customToolCall(OpenAICustomToolCallResource)
    case customToolCallOutput(OpenAICustomToolCallOutputResource)
    case fileSearchToolCall(OpenAIFileSearchToolCallResource)
    case functionShellCall(OpenAIFunctionShellCallResource)
    case functionShellCallOutput(OpenAIFunctionShellCallOutputResource)
    case functionToolCall(OpenAIFunctionToolCallResource)
    case functionToolCallOutput(OpenAIFunctionToolCallOutputResource)
    case imageGenToolCall(OpenAIImageGenToolCallResource)
    case localShellToolCall(OpenAILocalShellToolCallResource)
    case localShellToolCallOutput(OpenAILocalShellToolCallOutputResource)
    case mcpApprovalRequest(OpenAIMCPApprovalRequestResource)
    case mcpApprovalResponse(OpenAIMCPApprovalResponseResource)
    case mcpListTools(OpenAIMCPListToolsResource)
    case mcpToolCall(OpenAIMCPToolCallResource)
    case message(OpenAIMessageResource)
    case reasoning(OpenAIReasoningItemResource)
    case webSearchToolCall(OpenAIWebSearchToolCallResource)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "apply_patch_call":
            self = .applyPatchToolCall(try OpenAIApplyPatchToolCallResource(from: decoder))
        case "apply_patch_call_output":
            self = .applyPatchToolCallOutput(try OpenAIApplyPatchToolCallOutputResource(from: decoder))
        case "code_interpreter_call":
            self = .codeInterpreterToolCall(try OpenAICodeInterpreterToolCallResource(from: decoder))
        case "computer_call":
            self = .computerToolCall(try OpenAIComputerToolCallResource(from: decoder))
        case "computer_call_output":
            self = .computerToolCallOutput(try OpenAIComputerToolCallOutputResource(from: decoder))
        case "custom_tool_call":
            self = .customToolCall(try OpenAICustomToolCallResource(from: decoder))
        case "custom_tool_call_output":
            self = .customToolCallOutput(try OpenAICustomToolCallOutputResource(from: decoder))
        case "file_search_call":
            self = .fileSearchToolCall(try OpenAIFileSearchToolCallResource(from: decoder))
        case "function_call":
            self = .functionToolCall(try OpenAIFunctionToolCallResource(from: decoder))
        case "function_call_output":
            self = .functionToolCallOutput(try OpenAIFunctionToolCallOutputResource(from: decoder))
        case "image_generation_call":
            self = .imageGenToolCall(try OpenAIImageGenToolCallResource(from: decoder))
        case "local_shell_call":
            self = .localShellToolCall(try OpenAILocalShellToolCallResource(from: decoder))
        case "local_shell_call_output":
            self = .localShellToolCallOutput(try OpenAILocalShellToolCallOutputResource(from: decoder))
        case "mcp_approval_request":
            self = .mcpApprovalRequest(try OpenAIMCPApprovalRequestResource(from: decoder))
        case "mcp_approval_response":
            self = .mcpApprovalResponse(try OpenAIMCPApprovalResponseResource(from: decoder))
        case "mcp_call":
            self = .mcpToolCall(try OpenAIMCPToolCallResource(from: decoder))
        case "mcp_list_tools":
            self = .mcpListTools(try OpenAIMCPListToolsResource(from: decoder))
        case "message":
            self = .message(try OpenAIMessageResource(from: decoder))
        case "reasoning":
            self = .reasoning(try OpenAIReasoningItemResource(from: decoder))
        case "shell_call":
            self = .functionShellCall(try OpenAIFunctionShellCallResource(from: decoder))
        case "shell_call_output":
            self = .functionShellCallOutput(try OpenAIFunctionShellCallOutputResource(from: decoder))
        case "web_search_call":
            self = .webSearchToolCall(try OpenAIWebSearchToolCallResource(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown conversation item type: \(type)"
            )
        }
    }
}
