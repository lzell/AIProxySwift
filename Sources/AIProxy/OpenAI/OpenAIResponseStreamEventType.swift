//
//  OpenAIResponseStreamEventType.swift
//  AIProxy
//
//  Created by Matt Corey on 6/21/25.
//

/// Represents all possible event types in the OpenAI Streaming Responses API
/// https://platform.openai.com/docs/api-reference/responses/streaming
public enum OpenAIResponseStreamEventType: String {
    // MARK: - Response Lifecycle Events
    case responseCreated = "response.created"
    case responseInProgress = "response.in_progress"
    case responseCompleted = "response.completed"
    case responseFailed = "response.failed"
    case responseIncomplete = "response.incomplete"
    
    // MARK: - Output Item Events
    case responseOutputItemAdded = "response.output_item.added"
    case responseOutputItemDone = "response.output_item.done"
    
    // MARK: - Content Part Events
    case responseContentPartAdded = "response.content_part.added"
    case responseContentPartDone = "response.content_part.done"
    
    // MARK: - Output Text Events
    case responseOutputTextDelta = "response.output_text.delta"
    case responseOutputTextAnnotationAdded = "response.output_text.annotation.added"
    case responseOutputTextDone = "response.output_text.done"
    
    // MARK: - Refusal Events
    case responseRefusalDelta = "response.refusal.delta"
    case responseRefusalDone = "response.refusal.done"
    
    // MARK: - Function Call Events
    case responseFunctionCallArgumentsDelta = "response.function_call_arguments.delta"
    case responseFunctionCallArgumentsDone = "response.function_call_arguments.done"
    
    // MARK: - File Search Call Events
    case responseFileSearchCallInProgress = "response.file_search_call.in_progress"
    case responseFileSearchCallSearching = "response.file_search_call.searching"
    case responseFileSearchCallCompleted = "response.file_search_call.completed"
    
    // MARK: - Web Search Call Events
    case responseWebSearchCallInProgress = "response.web_search_call.in_progress"
    case responseWebSearchCallSearching = "response.web_search_call.searching"
    case responseWebSearchCallCompleted = "response.web_search_call.completed"
    
    // MARK: - Reasoning Events
    case responseReasoningDelta = "response.reasoning.delta"
    case responseReasoningDone = "response.reasoning.done"
    
    // MARK: - Reasoning Summary Events
    case responseReasoningSummaryPartAdded = "response.reasoning_summary_part.added"
    case responseReasoningSummaryPartDone = "response.reasoning_summary_part.done"
    case responseReasoningSummaryTextDelta = "response.reasoning_summary_text.delta"
    case responseReasoningSummaryTextDone = "response.reasoning_summary_text.done"
    case responseReasoningSummaryDelta = "response.reasoning_summary.delta"
    case responseReasoningSummaryDone = "response.reasoning_summary.done"
    
    // MARK: - Image Generation Events
    case responseImageGenerationCallInProgress = "response.image_generation_call.in_progress"
    case responseImageGenerationCallGenerating = "response.image_generation_call.generating"
    case responseImageGenerationCallCompleted = "response.image_generation_call.completed"
    case responseImageGenerationCallPartialImage = "response.image_generation_call.partial_image"
    
    // MARK: - MCP Call Events
    case responseMcpCallArgumentsDelta = "response.mcp_call.arguments.delta"
    case responseMcpCallArgumentsDone = "response.mcp_call.arguments.done"
    case responseMcpCallCompleted = "response.mcp_call.completed"
    case responseMcpCallFailed = "response.mcp_call.failed"
    
    // MARK: - MCP List Tools Events
    case responseMcpListToolsInProgress = "response.mcp_list_tools.in_progress"
    case responseMcpListToolsCompleted = "response.mcp_list_tools.completed"
    case responseMcpListToolsFailed = "response.mcp_list_tools.failed"
    
    
    // MARK: - Response Queue Events
    case responseQueued = "response.queued"
    
    // MARK: - Error Events
    case error = "error"
}
