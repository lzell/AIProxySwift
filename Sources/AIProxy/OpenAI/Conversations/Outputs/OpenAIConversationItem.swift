//
//  OpenAIConversationItem.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: ConversationItem, version 2.3.0, line 36122
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data

/// A single item within a conversation.
/// The set of possible types are the same as the `output` type of a Response object: https://platform.openai.com/docs/api-reference/responses/object#responses/object-output
/// For the corresponding Encodable input, see OpenAIItem
nonisolated public enum OpenAIConversationItem: Decodable, Sendable {
    /// A message to or from the model.
    case message(OpenAIMessage)

    /// A tool call to run a function. See the function calling guide for more information: https://platform.openai.com/docs/guides/function-calling
    case functionToolCall(OpenAIFunctionToolCall)

    /// The output of a function tool call.
    case functionToolCallOutput(OpenAIFunctionToolCallOutput)

    /// The results of a file search tool call. See the file search guide for more information: https://platform.openai.com/docs/guides/tools-file-search
    case fileSearchToolCall(OpenAIFileSearchToolCall)

    /// The results of a web search tool call. See the web search guide for more information: https://platform.openai.com/docs/guides/tools-web-search
    case webSearchToolCall(OpenAIWebSearchToolCall)

    /// An image generation request made by the model.
    case imageGenToolCall(OpenAIImageGenerationToolCall)

    /// A tool call to a computer use tool. See the computer use guide for more information: https://platform.openai.com/docs/guides/tools-computer-use
    case computerToolCall(OpenAIComputerToolCall)

    /// The output of a computer tool call.
    case computerToolCallOutput(OpenAIComputerToolCallOutput)

    /// A description of the chain of thought used by a reasoning model while generating a response.
    /// Be sure to include these items in your input to the Responses API for subsequent turns of a conversation if you are manually managing context: https://platform.openai.com/docs/guides/conversation-state
    case reasoning(OpenAIReasoningItem)

    /// A tool call to run code.
    case codeInterpreterToolCall(OpenAICodeInterpreterToolCall)

    /// A tool call to run a command on the local shell.
    case localShellToolCall(OpenAILocalShellToolCall)

    /// The output of a local shell tool call.
    case localShellToolCallOutput(OpenAILocalShellToolCallOutput)

    /// A tool call that executes one or more shell commands in a managed environment.
    case functionShellCall(OpenAIShellToolCall)

    /// The output of a shell tool call.
    case functionShellCallOutput(OpenAIShellToolCallOutput)

    /// A tool call that applies file diffs by creating, deleting, or updating files.
    case applyPatchToolCall(OpenAIApplyPatchToolCall)

    /// The output emitted by an apply patch tool call.
    case applyPatchToolCallOutput(OpenAIApplyPatchToolCallOutput)

    /// A list of tools available on an MCP server.
    case mcpListTools(OpenAIMCPListTools)

    /// A request for human approval of a tool invocation.
    case mcpApprovalRequest(OpenAIMCPApprovalRequest)

    /// A response to an MCP approval request.
    case mcpApprovalResponse(OpenAIMCPApprovalResponse)

    /// An invocation of a tool on an MCP server.
    case mcpToolCall(OpenAIMCPToolCall)

    /// A call to a custom tool created by the model.
    case customToolCall(OpenAICustomToolCall)

    /// The output of a custom tool call from your code, being sent back to the model.
    case customToolCallOutput(OpenAICustomToolCall)

    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "apply_patch_call":
            self = .applyPatchToolCall(try OpenAIApplyPatchToolCall(from: decoder))
        case "apply_patch_call_output":
            self = .applyPatchToolCallOutput(try OpenAIApplyPatchToolCallOutput(from: decoder))
        case "code_interpreter_call":
            self = .codeInterpreterToolCall(try OpenAICodeInterpreterToolCall(from: decoder))
        case "computer_call":
            self = .computerToolCall(try OpenAIComputerToolCall(from: decoder))
        case "computer_call_output":
            self = .computerToolCallOutput(try OpenAIComputerToolCallOutput(from: decoder))
        case "custom_tool_call":
            self = .customToolCall(try OpenAICustomToolCall(from: decoder))
        case "custom_tool_call_output":
            self = .customToolCallOutput(try OpenAICustomToolCall(from: decoder))
        case "file_search_call":
            self = .fileSearchToolCall(try OpenAIFileSearchToolCall(from: decoder))
        case "function_call":
            self = .functionToolCall(try OpenAIFunctionToolCall(from: decoder))
        case "function_call_output":
            self = .functionToolCallOutput(try OpenAIFunctionToolCallOutput(from: decoder))
        case "image_generation_call":
            self = .imageGenToolCall(try OpenAIImageGenerationToolCall(from: decoder))
        case "local_shell_call":
            self = .localShellToolCall(try OpenAILocalShellToolCall(from: decoder))
        case "local_shell_call_output":
            self = .localShellToolCallOutput(try OpenAILocalShellToolCallOutput(from: decoder))
        case "mcp_approval_request":
            self = .mcpApprovalRequest(try OpenAIMCPApprovalRequest(from: decoder))
        case "mcp_approval_response":
            self = .mcpApprovalResponse(try OpenAIMCPApprovalResponse(from: decoder))
        case "mcp_call":
            self = .mcpToolCall(try OpenAIMCPToolCall(from: decoder))
        case "mcp_list_tools":
            self = .mcpListTools(try OpenAIMCPListTools(from: decoder))
        case "message":
            self = .message(try OpenAIMessage(from: decoder))
        case "reasoning":
            self = .reasoning(try OpenAIReasoningItem(from: decoder))
        case "shell_call":
            self = .functionShellCall(try OpenAIShellToolCall(from: decoder))
        case "shell_call_output":
            self = .functionShellCallOutput(try OpenAIShellToolCallOutput(from: decoder))
        case "web_search_call":
            self = .webSearchToolCall(try OpenAIWebSearchToolCall(from: decoder))
        default:
            self = .futureProof
            logIf(.error)?.error("Unknown conversation item type: \(type)")
        }
    }
}
