//
//  OpenAIResponseStreamingEvent.swift
//  AIProxy
//
//  Created by Matt Corey on 6/21/25.
//

import Foundation

/// Represents a streaming event from the OpenAI Responses API
public struct OpenAIResponseStreamingEvent: Decodable {
    /// The type of event
    public let type: OpenAIResponseStreamEventType
    
    /// The sequence number of this event
    public let sequenceNumber: Int
    
    /// The event-specific data
    public let data: EventData
    
    private enum CodingKeys: String, CodingKey {
        case type
        case sequenceNumber = "sequence_number"
        case response
        case outputIndex = "output_index"
        case item
        case itemId = "item_id"
        case contentIndex = "content_index"
        case summaryIndex = "summary_index"
        case part
        case delta
        case text
        case refusal
        case arguments
        case partialImageIndex = "partial_image_index"
        case partialImageB64 = "partial_image_b64"
        case annotationIndex = "annotation_index"
        case annotation
        case code
        case message
        case param
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        
        guard let eventType = OpenAIResponseStreamEventType(rawValue: typeString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown event type: \(typeString)"
            )
        }
        
        self.type = eventType
        self.sequenceNumber = try container.decode(Int.self, forKey: .sequenceNumber)
        
        // Decode based on event type
        switch eventType {
        case .responseCreated:
            let responseData = try container.decode(ResponseCreatedData.self, forKey: .response)
            self.data = .responseCreated(responseData)
            
        case .responseInProgress:
            let responseData = try container.decode(ResponseInProgressData.self, forKey: .response)
            self.data = .responseInProgress(responseData)
            
        case .responseCompleted:
            let responseData = try container.decode(ResponseCompletedData.self, forKey: .response)
            self.data = .responseCompleted(responseData)
            
        case .responseFailed:
            let responseData = try container.decode(ResponseFailedData.self, forKey: .response)
            self.data = .responseFailed(responseData)
            
        case .responseIncomplete:
            let responseData = try container.decode(ResponseIncompleteData.self, forKey: .response)
            self.data = .responseIncomplete(responseData)
            
        case .responseOutputItemAdded:
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let item = try container.decode(PartialOutputItem.self, forKey: .item)
            self.data = .outputItemAdded(OutputItemAddedData(index: outputIndex, item: item))
            
        case .responseOutputItemDone:
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let item = try container.decode(OpenAIResponse.ResponseOutputItem.self, forKey: .item)
            self.data = .outputItemDone(OutputItemDoneData(index: outputIndex, item: item))
            
        case .responseContentPartAdded:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let part = try container.decode(PartialContentPart.self, forKey: .part)
            self.data = .contentPartAdded(ContentPartAddedData(
                index: contentIndex,
                outputItemIndex: outputIndex,
                part: part
            ))
            
        case .responseContentPartDone:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let part = try container.decode(OpenAIResponse.Content.self, forKey: .part)
            self.data = .contentPartDone(ContentPartDoneData(
                index: contentIndex,
                outputItemIndex: outputIndex,
                part: part
            ))
            
        case .responseOutputTextDelta:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let delta = try container.decode(String.self, forKey: .delta)
            self.data = .outputTextDelta(OutputTextDeltaData(
                outputItemIndex: outputIndex,
                contentPartIndex: contentIndex,
                delta: delta
            ))
            
        case .responseOutputTextDone:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let text = try container.decode(String.self, forKey: .text)
            self.data = .outputTextDone(OutputTextDoneData(
                outputItemIndex: outputIndex,
                contentPartIndex: contentIndex,
                text: text
            ))
            
        case .responseRefusalDelta:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let delta = try container.decode(String.self, forKey: .delta)
            self.data = .refusalDelta(RefusalDeltaData(
                outputItemIndex: outputIndex,
                contentPartIndex: contentIndex,
                delta: delta
            ))
            
        case .responseRefusalDone:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let refusal = try container.decode(String.self, forKey: .refusal)
            self.data = .refusalDone(RefusalDoneData(
                outputItemIndex: outputIndex,
                contentPartIndex: contentIndex,
                refusal: refusal
            ))
            
        case .responseFunctionCallArgumentsDelta:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let delta = try container.decode(String.self, forKey: .delta)
            self.data = .functionCallArgumentsDelta(FunctionCallArgumentsDeltaData(
                outputItemIndex: outputIndex,
                callId: "", // Will need to update this based on actual API response
                delta: delta
            ))
            
        case .responseFunctionCallArgumentsDone:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let arguments = try container.decode(String.self, forKey: .arguments)
            self.data = .functionCallArgumentsDone(FunctionCallArgumentsDoneData(
                outputItemIndex: outputIndex,
                callId: "", // Will need to update this based on actual API response
                arguments: arguments
            ))
            
        case .responseFileSearchCallInProgress, .responseFileSearchCallSearching, .responseFileSearchCallCompleted:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            self.data = .fileSearchCallProgress(FileSearchCallProgressData(
                outputItemIndex: outputIndex,
                id: "", // Will need to update based on actual API
                status: typeString.components(separatedBy: ".").last ?? "",
                queries: nil,
                results: nil
            ))
            
        case .responseWebSearchCallInProgress, .responseWebSearchCallSearching, .responseWebSearchCallCompleted:
            _ = try container.decode(String.self, forKey: .itemId) // itemId is not used in the data structure
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            self.data = .webSearchCallProgress(WebSearchCallProgressData(
                outputItemIndex: outputIndex,
                id: "", // Will need to update based on actual API
                status: typeString.components(separatedBy: ".").last ?? ""
            ))
            
        case .responseReasoningSummaryPartAdded:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let part = try container.decode(ReasoningSummaryPart.self, forKey: .part)
            self.data = .reasoningSummaryPartAdded(ReasoningSummaryPartAddedData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                part: part
            ))
            
        case .responseReasoningSummaryPartDone:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let part = try container.decode(ReasoningSummaryPart.self, forKey: .part)
            self.data = .reasoningSummaryPartDone(ReasoningSummaryPartDoneData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                part: part
            ))
            
        case .responseReasoningSummaryTextDelta:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let delta = try container.decode(String.self, forKey: .delta)
            self.data = .reasoningSummaryTextDelta(ReasoningSummaryTextDeltaData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                delta: delta
            ))
            
        case .responseReasoningSummaryTextDone:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let text = try container.decode(String.self, forKey: .text)
            self.data = .reasoningSummaryTextDone(ReasoningSummaryTextDoneData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                text: text
            ))
            
        case .responseReasoningSummaryDelta:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let delta = try container.decode(AIProxyJSONValue.self, forKey: .delta)
            self.data = .reasoningSummaryDelta(ReasoningSummaryDeltaData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                delta: delta
            ))
            
        case .responseReasoningSummaryDone:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let summaryIndex = try container.decode(Int.self, forKey: .summaryIndex)
            let text = try container.decode(String.self, forKey: .text)
            self.data = .reasoningSummaryDone(ReasoningSummaryDoneData(
                outputIndex: outputIndex,
                summaryIndex: summaryIndex,
                text: text
            ))
            
        case .responseImageGenerationCallInProgress, .responseImageGenerationCallGenerating, .responseImageGenerationCallCompleted:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            self.data = .imageGenerationCallProgress(ImageGenerationCallProgressData(
                outputIndex: outputIndex,
                status: typeString.components(separatedBy: ".").last ?? ""
            ))
            
        case .responseImageGenerationCallPartialImage:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let partialImageIndex = try container.decode(Int.self, forKey: .partialImageIndex)
            let partialImageB64 = try container.decode(String.self, forKey: .partialImageB64)
            self.data = .imageGenerationCallPartialImage(ImageGenerationCallPartialImageData(
                outputIndex: outputIndex,
                partialImageIndex: partialImageIndex,
                partialImageB64: partialImageB64
            ))
            
        case .responseMcpCallArgumentsDelta:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let delta = try container.decode(AIProxyJSONValue.self, forKey: .delta)
            self.data = .mcpCallArgumentsDelta(McpCallArgumentsDeltaData(
                outputIndex: outputIndex,
                delta: delta
            ))
            
        case .responseMcpCallArgumentsDone:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let arguments = try container.decode(AIProxyJSONValue.self, forKey: .arguments)
            self.data = .mcpCallArgumentsDone(McpCallArgumentsDoneData(
                outputIndex: outputIndex,
                arguments: arguments
            ))
            
        case .responseMcpCallCompleted, .responseMcpCallFailed:
            self.data = .mcpCallProgress(McpCallProgressData(
                status: typeString.components(separatedBy: ".").last ?? ""
            ))
            
        case .responseMcpListToolsInProgress, .responseMcpListToolsCompleted, .responseMcpListToolsFailed:
            self.data = .mcpListToolsProgress(McpListToolsProgressData(
                status: typeString.components(separatedBy: ".").last ?? ""
            ))
            
        case .responseOutputTextAnnotationAdded:
            _ = try container.decode(String.self, forKey: .itemId)
            let outputIndex = try container.decode(Int.self, forKey: .outputIndex)
            let contentIndex = try container.decode(Int.self, forKey: .contentIndex)
            let annotationIndex = try container.decode(Int.self, forKey: .annotationIndex)
            let annotation = try container.decode(AIProxyJSONValue.self, forKey: .annotation)
            self.data = .outputTextAnnotationAdded(OutputTextAnnotationAddedData(
                outputItemIndex: outputIndex,
                contentPartIndex: contentIndex,
                annotationIndex: annotationIndex,
                annotation: annotation
            ))
            
        case .responseQueued:
            let responseData = try container.decode(AIProxyJSONValue.self, forKey: .response)
            self.data = .responseQueued(ResponseQueuedData(response: responseData))
            
        case .error:
            let code = try container.decode(String.self, forKey: .code)
            let message = try container.decode(String.self, forKey: .message)
            let param = try container.decodeIfPresent(String.self, forKey: .param)
            self.data = .error(ErrorData(code: code, message: message, param: param))
            
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Event type \(typeString) parsing not yet implemented"
            )
        }
    }
    
}

// MARK: - Event Data
extension OpenAIResponseStreamingEvent {
    /// Contains the event-specific data based on the event type
    public enum EventData {
        case responseCreated(ResponseCreatedData)
        case responseInProgress(ResponseInProgressData)
        case responseCompleted(ResponseCompletedData)
        case responseFailed(ResponseFailedData)
        case responseIncomplete(ResponseIncompleteData)
        case outputItemAdded(OutputItemAddedData)
        case outputItemDone(OutputItemDoneData)
        case contentPartAdded(ContentPartAddedData)
        case contentPartDone(ContentPartDoneData)
        case outputTextDelta(OutputTextDeltaData)
        case outputTextDone(OutputTextDoneData)
        case outputTextAnnotationAdded(OutputTextAnnotationAddedData)
        case refusalDelta(RefusalDeltaData)
        case refusalDone(RefusalDoneData)
        case functionCallArgumentsDelta(FunctionCallArgumentsDeltaData)
        case functionCallArgumentsDone(FunctionCallArgumentsDoneData)
        case fileSearchCallProgress(FileSearchCallProgressData)
        case webSearchCallProgress(WebSearchCallProgressData)
        case audioDelta(AudioDeltaData)
        case audioDone(AudioDoneData)
        case audioTranscriptDelta(AudioTranscriptDeltaData)
        case audioTranscriptDone(AudioTranscriptDoneData)
        case codeInterpreterCallProgress(CodeInterpreterCallProgressData)
        case computerCallProgress(ComputerCallProgressData)
        case reasoningDelta(ReasoningDeltaData)
        case reasoningDone(ReasoningDoneData)
        case reasoningSummaryPartAdded(ReasoningSummaryPartAddedData)
        case reasoningSummaryPartDone(ReasoningSummaryPartDoneData)
        case reasoningSummaryTextDelta(ReasoningSummaryTextDeltaData)
        case reasoningSummaryTextDone(ReasoningSummaryTextDoneData)
        case reasoningSummaryDelta(ReasoningSummaryDeltaData)
        case reasoningSummaryDone(ReasoningSummaryDoneData)
        case imageGenerationCallProgress(ImageGenerationCallProgressData)
        case imageGenerationCallPartialImage(ImageGenerationCallPartialImageData)
        case mcpCallArgumentsDelta(McpCallArgumentsDeltaData)
        case mcpCallArgumentsDone(McpCallArgumentsDoneData)
        case mcpCallProgress(McpCallProgressData)
        case mcpListToolsProgress(McpListToolsProgressData)
        case responseQueued(ResponseQueuedData)
        case error(ErrorData)
        
    }
}

// MARK: - Response Lifecycle Events
extension OpenAIResponseStreamingEvent {
    public struct ResponseCreatedData: Decodable {
        public let id: String
        public let object: String
        public let model: String
        public let createdAt: Double
        public let status: OpenAIResponse.Status
        public let error: String?
        public let incompleteDetails: String?
        public let instructions: String?
        public let maxOutputTokens: Int?
        public let output: [AIProxyJSONValue]
        public let parallelToolCalls: Bool
        public let previousResponseId: String?
        public let reasoning: ReasoningData?
        public let store: Bool
        public let temperature: Double
        public let text: TextFormat?
        public let toolChoice: String
        public let tools: [AIProxyJSONValue]
        public let topP: Double
        public let truncation: String
        public let usage: OpenAIResponse.ResponseUsage?
        public let user: String?
        public let metadata: [String: String]
        
        private enum CodingKeys: String, CodingKey {
            case id, object, model, status, error, instructions, output, tools, metadata, user, usage, truncation
            case createdAt = "created_at"
            case incompleteDetails = "incomplete_details"
            case maxOutputTokens = "max_output_tokens"
            case parallelToolCalls = "parallel_tool_calls"
            case previousResponseId = "previous_response_id"
            case reasoning
            case store, temperature, text
            case toolChoice = "tool_choice"
            case topP = "top_p"
        }
    }
    
    public struct ReasoningData: Decodable {
        public let effort: String?
        public let summary: String?
    }
    
    public struct TextFormat: Decodable {
        public let format: FormatType
        
        public struct FormatType: Decodable {
            public let type: String
            public let description: String?
            public let name: String?
            public let schema: AIProxyJSONValue?
            public let strict: Bool?
            
            private enum CodingKeys: String, CodingKey {
                case type, description, name, schema, strict
            }
        }
    }
    
    public struct ResponseInProgressData: Decodable {
        public let id: String
        public let object: String
        public let model: String
        public let createdAt: Double
        public let status: OpenAIResponse.Status
        public let error: String?
        public let incompleteDetails: String?
        public let instructions: String?
        public let maxOutputTokens: Int?
        public let output: [AIProxyJSONValue]
        public let parallelToolCalls: Bool
        public let previousResponseId: String?
        public let reasoning: ReasoningData?
        public let store: Bool
        public let temperature: Double
        public let text: TextFormat?
        public let toolChoice: String
        public let tools: [AIProxyJSONValue]
        public let topP: Double
        public let truncation: String
        public let usage: OpenAIResponse.ResponseUsage?
        public let user: String?
        public let metadata: [String: String]
        
        private enum CodingKeys: String, CodingKey {
            case id, object, model, status, error, instructions, output, tools, metadata, user, usage, truncation
            case createdAt = "created_at"
            case incompleteDetails = "incomplete_details"
            case maxOutputTokens = "max_output_tokens"
            case parallelToolCalls = "parallel_tool_calls"
            case previousResponseId = "previous_response_id"
            case reasoning
            case store, temperature, text
            case toolChoice = "tool_choice"
            case topP = "top_p"
        }
    }
    
    public struct ResponseCompletedData: Decodable {
        public let id: String
        public let object: String
        public let model: String
        public let createdAt: Double
        public let status: OpenAIResponse.Status
        public let error: String?
        public let incompleteDetails: String?
        public let input: [AIProxyJSONValue]?
        public let instructions: String?
        public let maxOutputTokens: Int?
        public let output: [OpenAIResponse.ResponseOutputItem]
        public let previousResponseId: String?
        public let reasoningEffort: String?
        public let store: Bool
        public let temperature: Double
        public let text: TextFormat?
        public let toolChoice: String
        public let tools: [AIProxyJSONValue]
        public let topP: Double
        public let truncation: String
        public let usage: OpenAIResponse.ResponseUsage?
        public let user: String?
        public let metadata: [String: String]
        
        private enum CodingKeys: String, CodingKey {
            case id, object, model, status, error, instructions, input, output, tools, metadata, user, usage, truncation
            case createdAt = "created_at"
            case incompleteDetails = "incomplete_details"
            case maxOutputTokens = "max_output_tokens"
            case previousResponseId = "previous_response_id"
            case reasoningEffort = "reasoning_effort"
            case store, temperature, text
            case toolChoice = "tool_choice"
            case topP = "top_p"
        }
    }
    
    public struct ResponseFailedData: Decodable {
        public let id: String
        public let object: String
        public let createdAt: Double
        public let status: OpenAIResponse.Status
        public let error: OpenAIResponse.ResponseError
        public let incompleteDetails: String?
        public let instructions: String?
        public let maxOutputTokens: Int?
        public let model: String
        public let output: [OpenAIResponse.ResponseOutputItem]
        public let previousResponseId: String?
        public let reasoningEffort: String?
        public let store: Bool
        public let temperature: Double
        public let text: TextFormat?
        public let toolChoice: String
        public let tools: [String]
        public let topP: Double
        public let truncation: String
        public let usage: OpenAIResponse.ResponseUsage?
        public let user: String?
        public let metadata: [String: String]
        
        private enum CodingKeys: String, CodingKey {
            case id, object, status, error, instructions, model, output, store, temperature, text, tools, usage, user, metadata, truncation
            case createdAt = "created_at"
            case incompleteDetails = "incomplete_details"
            case maxOutputTokens = "max_output_tokens"
            case previousResponseId = "previous_response_id"
            case reasoningEffort = "reasoning_effort"
            case toolChoice = "tool_choice"
            case topP = "top_p"
        }
    }
    
    public struct ResponseIncompleteData: Decodable {
        public let id: String
        public let object: String
        public let createdAt: Double
        public let status: OpenAIResponse.Status
        public let error: String?
        public let incompleteDetails: OpenAIResponse.IncompleteDetails
        public let instructions: String?
        public let maxOutputTokens: Int?
        public let model: String
        public let output: [OpenAIResponse.ResponseOutputItem]
        public let previousResponseId: String?
        public let reasoningEffort: String?
        public let store: Bool
        public let temperature: Double
        public let text: TextFormat?
        public let toolChoice: String
        public let tools: [String]
        public let topP: Double
        public let truncation: String
        public let usage: OpenAIResponse.ResponseUsage?
        public let user: String?
        public let metadata: [String: String]
        
        private enum CodingKeys: String, CodingKey {
            case id, object, status, error, instructions, model, output, store, temperature, text, tools, usage, user, metadata, truncation
            case createdAt = "created_at"
            case incompleteDetails = "incomplete_details"
            case maxOutputTokens = "max_output_tokens"
            case previousResponseId = "previous_response_id"
            case reasoningEffort = "reasoning_effort"
            case toolChoice = "tool_choice"
            case topP = "top_p"
        }
    }
}

// MARK: - Output Item Events
extension OpenAIResponseStreamingEvent {
    public struct OutputItemAddedData: Decodable {
        public let index: Int
        public let item: PartialOutputItem
    }
    
    public struct OutputItemDoneData: Decodable {
        public let index: Int
        public let item: OpenAIResponse.ResponseOutputItem
    }
    
    /// Represents a partial output item during streaming
    public struct PartialOutputItem: Decodable {
        public let type: String
        public let id: String?
        public let status: String?
        
        // For message type
        public let role: String?
        public let content: [PartialContentPart]?
        
        // For tool calls
        public let callId: String?
        public let name: String?
        
        private enum CodingKeys: String, CodingKey {
            case type
            case id
            case status
            case role
            case content
            case callId = "call_id"
            case name
        }
    }
}

// MARK: - Content Part Events
extension OpenAIResponseStreamingEvent {
    public struct ContentPartAddedData: Decodable {
        public let index: Int
        public let outputItemIndex: Int
        public let part: PartialContentPart
        
        private enum CodingKeys: String, CodingKey {
            case index
            case outputItemIndex = "output_item_index"
            case part
        }
    }
    
    public struct ContentPartDoneData: Decodable {
        public let index: Int
        public let outputItemIndex: Int
        public let part: OpenAIResponse.Content
        
        private enum CodingKeys: String, CodingKey {
            case index
            case outputItemIndex = "output_item_index"
            case part
        }
    }
    
    public struct PartialContentPart: Decodable {
        public let type: String
        public let annotations: [String]?
        public let text: String?
    }
}

// MARK: - Text Events
extension OpenAIResponseStreamingEvent {
    public struct OutputTextDeltaData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }
    
    public struct OutputTextAnnotationAddedData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let annotationIndex: Int
        public let annotation: AIProxyJSONValue
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case annotationIndex = "annotation_index"
            case annotation
        }
    }
    
    public struct OutputTextDoneData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let text: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case text
        }
    }
}

// MARK: - Refusal Events
extension OpenAIResponseStreamingEvent {
    public struct RefusalDeltaData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }
    
    public struct RefusalDoneData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let refusal: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case refusal
        }
    }
}

// MARK: - Function Call Events
extension OpenAIResponseStreamingEvent {
    public struct FunctionCallArgumentsDeltaData: Decodable {
        public let outputItemIndex: Int
        public let callId: String
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case callId = "call_id"
            case delta
        }
    }
    
    public struct FunctionCallArgumentsDoneData: Decodable {
        public let outputItemIndex: Int
        public let callId: String
        public let arguments: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case callId = "call_id"
            case arguments
        }
    }
}

// MARK: - Search Call Events
extension OpenAIResponseStreamingEvent {
    public struct FileSearchCallProgressData: Decodable {
        public let outputItemIndex: Int
        public let id: String
        public let status: String
        public let queries: [String]?
        public let results: [OpenAIResponse.FileSearchCall.FileSearchResult]?
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case id
            case status
            case queries
            case results
        }
    }
    
    public struct WebSearchCallProgressData: Decodable {
        public let outputItemIndex: Int
        public let id: String
        public let status: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case id
            case status
        }
    }
}

// MARK: - Audio Events
extension OpenAIResponseStreamingEvent {
    public struct AudioDeltaData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String // Base64 encoded audio data
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }
    
    public struct AudioDoneData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
        }
    }
    
    public struct AudioTranscriptDeltaData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }
    
    public struct AudioTranscriptDoneData: Decodable {
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let transcript: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case transcript
        }
    }
}

// MARK: - Code Interpreter and Computer Call Events
extension OpenAIResponseStreamingEvent {
    public struct CodeInterpreterCallProgressData: Decodable {
        public let outputItemIndex: Int
        public let id: String
        public let status: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case id
            case status
        }
    }
    
    public struct ComputerCallProgressData: Decodable {
        public let outputItemIndex: Int
        public let id: String
        public let callId: String
        public let status: String
        public let action: OpenAIResponse.ComputerAction?
        public let pendingSafetyChecks: [OpenAIResponse.SafetyCheck]?
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case id
            case callId = "call_id"
            case status
            case action
            case pendingSafetyChecks = "pending_safety_checks"
        }
    }
}

// MARK: - Reasoning Events
extension OpenAIResponseStreamingEvent {
    public struct ReasoningDeltaData: Decodable {
        public let outputItemIndex: Int
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case delta
        }
    }
    
    public struct ReasoningDoneData: Decodable {
        public let outputItemIndex: Int
        public let reasoning: String
        
        private enum CodingKeys: String, CodingKey {
            case outputItemIndex = "output_item_index"
            case reasoning
        }
    }
}

// MARK: - Reasoning Summary Events
extension OpenAIResponseStreamingEvent {
    public struct ReasoningSummaryPart: Decodable {
        public let type: String
        public let text: String?
    }
    
    public struct ReasoningSummaryPartAddedData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: ReasoningSummaryPart
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case part
        }
    }
    
    public struct ReasoningSummaryPartDoneData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: ReasoningSummaryPart
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case part
        }
    }
    
    public struct ReasoningSummaryTextDeltaData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let delta: String
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case delta
        }
    }
    
    public struct ReasoningSummaryTextDoneData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let text: String
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case text
        }
    }
    
    public struct ReasoningSummaryDeltaData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let delta: AIProxyJSONValue
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case delta
        }
    }
    
    public struct ReasoningSummaryDoneData: Decodable {
        public let outputIndex: Int
        public let summaryIndex: Int
        public let text: String
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case text
        }
    }
}

// MARK: - Image Generation Events
extension OpenAIResponseStreamingEvent {
    public struct ImageGenerationCallProgressData: Decodable {
        public let outputIndex: Int
        public let status: String
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case status
        }
    }
    
    public struct ImageGenerationCallPartialImageData: Decodable {
        public let outputIndex: Int
        public let partialImageIndex: Int
        public let partialImageB64: String
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case partialImageIndex = "partial_image_index"
            case partialImageB64 = "partial_image_b64"
        }
    }
}

// MARK: - MCP Call Events
extension OpenAIResponseStreamingEvent {
    public struct McpCallArgumentsDeltaData: Decodable {
        public let outputIndex: Int
        public let delta: AIProxyJSONValue
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case delta
        }
    }
    
    public struct McpCallArgumentsDoneData: Decodable {
        public let outputIndex: Int
        public let arguments: AIProxyJSONValue
        
        private enum CodingKeys: String, CodingKey {
            case outputIndex = "output_index"
            case arguments
        }
    }
    
    public struct McpCallProgressData: Decodable {
        public let status: String
    }
    
    public struct McpListToolsProgressData: Decodable {
        public let status: String
    }
}


// MARK: - Response Queue Events
extension OpenAIResponseStreamingEvent {
    public struct ResponseQueuedData: Decodable {
        public let response: AIProxyJSONValue
    }
}

// MARK: - Error Events
extension OpenAIResponseStreamingEvent {
    public struct ErrorData: Decodable {
        public let code: String
        public let message: String
        public let param: String?
    }
}
