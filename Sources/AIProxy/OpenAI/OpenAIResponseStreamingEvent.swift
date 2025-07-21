//
//  OpenAIResponseStreamingEvent.swift
//  AIProxy
//
//  Created by Matt Corey on 6/21/25.
//

import Foundation

/// Represents a streaming event from the OpenAI Responses API
/// https://platform.openai.com/docs/api-reference/responses-streaming/response
public enum OpenAIResponseStreamingEvent: Decodable {
    case responseCreated(ResponseCreated)
    case responseInProgress(ResponseInProgress)
    case responseCompleted(ResponseCompleted)
    case responseFailed(ResponseFailed)
    case responseIncomplete(ResponseIncomplete)
    case outputItemAdded(OutputItemAdded)
    case outputItemDone(OutputItemDone)
    case contentPartAdded(ContentPartAdded)
    case contentPartDone(ContentPartDone)
    case outputTextDelta(OutputTextDelta)
    case outputTextDone(OutputTextDone)
    case outputTextAnnotationAdded(OutputTextAnnotationAdded)
    case refusalDelta(RefusalDelta)
    case refusalDone(RefusalDone)
    case functionCallArgumentsDelta(FunctionCallArgumentsDelta)
    case functionCallArgumentsDone(FunctionCallArgumentsDone)
    case fileSearchCallInProgress(FileSearchCallInProgress)
    case fileSearchCallSearching(FileSearchCallSearching)
    case fileSearchCallCompleted(FileSearchCallCompleted)
    case webSearchCallInProgress(WebSearchCallInProgress)
    case webSearchCallSearching(WebSearchCallSearching)
    case webSearchCallCompleted(WebSearchCallCompleted)
    case audioDelta(AudioDelta)
    case audioDone(AudioDone)
    case audioTranscriptDelta(AudioTranscriptDelta)
    case audioTranscriptDone(AudioTranscriptDone)
    case codeInterpreterCallProgress(CodeInterpreterCallProgress)
    case computerCallProgress(ComputerCallProgress)
    case reasoningDelta(ReasoningDelta)
    case reasoningDone(ReasoningDone)
    case reasoningSummaryPartAdded(ReasoningSummaryPartAdded)
    case reasoningSummaryPartDone(ReasoningSummaryPartDone)
    case reasoningSummaryTextDelta(ReasoningSummaryTextDelta)
    case reasoningSummaryTextDone(ReasoningSummaryTextDone)
    case reasoningSummaryDelta(ReasoningSummaryDelta)
    case reasoningSummaryDone(ReasoningSummaryDone)
    case imageGenerationCallProgress(ImageGenerationCallProgress)
    case imageGenerationCallPartialImage(ImageGenerationCallPartialImage)
    case mcpCallArgumentsDelta(McpCallArgumentsDelta)
    case mcpCallArgumentsDone(McpCallArgumentsDone)
    case mcpCallProgress(McpCallProgress)
    case mcpListToolsProgress(McpListToolsProgress)
    case responseQueued(ResponseQueued)
    case error(ErrorEvent)

    private enum CodingKeys: String, CodingKey {
        case type
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

        switch eventType {
        case .responseCreated:
            self = .responseCreated(try ResponseCreated(from: decoder))

        case .responseInProgress:
            self = .responseInProgress(try ResponseInProgress(from: decoder))

        case .responseCompleted:
            self = .responseCompleted(try ResponseCompleted(from: decoder))

        case .responseFailed:
            self = .responseFailed(try ResponseFailed(from: decoder))

        case .responseIncomplete:
            self = .responseIncomplete(try ResponseIncomplete(from: decoder))

        case .responseOutputItemAdded:
            self = .outputItemAdded(try OutputItemAdded(from: decoder))

        case .responseOutputItemDone:
            self = .outputItemDone(try OutputItemDone(from: decoder))

        case .responseContentPartAdded:
            self = .contentPartAdded(try ContentPartAdded(from: decoder))

        case .responseContentPartDone:
            self = .contentPartDone(try ContentPartDone(from: decoder))

        case .responseOutputTextDelta:
            self = .outputTextDelta(try OutputTextDelta(from: decoder))

        case .responseOutputTextDone:
            self = .outputTextDone(try OutputTextDone(from: decoder))

        case .responseRefusalDelta:
            self = .refusalDelta(try RefusalDelta(from: decoder))

        case .responseRefusalDone:
            self = .refusalDone(try RefusalDone(from: decoder))

        case .responseFunctionCallArgumentsDelta:
            self = .functionCallArgumentsDelta(try FunctionCallArgumentsDelta(from: decoder))

        case .responseFunctionCallArgumentsDone:
            self = .functionCallArgumentsDone(try FunctionCallArgumentsDone(from: decoder))

        case .responseFileSearchCallInProgress:
            self = .fileSearchCallInProgress(try FileSearchCallInProgress(from: decoder))

        case .responseFileSearchCallSearching:
            self = .fileSearchCallSearching(try FileSearchCallSearching(from: decoder))

        case .responseFileSearchCallCompleted:
            self = .fileSearchCallCompleted(try FileSearchCallCompleted(from: decoder))

        case .responseWebSearchCallInProgress:
            self = .webSearchCallInProgress(try WebSearchCallInProgress(from: decoder))

        case .responseWebSearchCallSearching:
            self = .webSearchCallSearching(try WebSearchCallSearching(from: decoder))

        case .responseWebSearchCallCompleted:
            self = .webSearchCallCompleted(try WebSearchCallCompleted(from: decoder))

        case .responseReasoningSummaryPartAdded:
            self = .reasoningSummaryPartAdded(try ReasoningSummaryPartAdded(from: decoder))

        case .responseReasoningSummaryPartDone:
            self = .reasoningSummaryPartDone(try ReasoningSummaryPartDone(from: decoder))

        case .responseReasoningSummaryTextDelta:
            self = .reasoningSummaryTextDelta(try ReasoningSummaryTextDelta(from: decoder))

        case .responseReasoningSummaryTextDone:
            self = .reasoningSummaryTextDone(try ReasoningSummaryTextDone(from: decoder))

        case .responseReasoningSummaryDelta:
            self = .reasoningSummaryDelta(try ReasoningSummaryDelta(from: decoder))

        case .responseReasoningSummaryDone:
            self = .reasoningSummaryDone(try ReasoningSummaryDone(from: decoder))

        case .responseImageGenerationCallInProgress, .responseImageGenerationCallGenerating, .responseImageGenerationCallCompleted:
            self = .imageGenerationCallProgress(try ImageGenerationCallProgress(from: decoder))

        case .responseImageGenerationCallPartialImage:
            self = .imageGenerationCallPartialImage(try ImageGenerationCallPartialImage(from: decoder))

        case .responseMcpCallArgumentsDelta:
            self = .mcpCallArgumentsDelta(try McpCallArgumentsDelta(from: decoder))

        case .responseMcpCallArgumentsDone:
            self = .mcpCallArgumentsDone(try McpCallArgumentsDone(from: decoder))

        case .responseMcpCallCompleted, .responseMcpCallFailed:
            self = .mcpCallProgress(try McpCallProgress(from: decoder))

        case .responseMcpListToolsInProgress, .responseMcpListToolsCompleted, .responseMcpListToolsFailed:
            self = .mcpListToolsProgress(try McpListToolsProgress(from: decoder))

        case .responseOutputTextAnnotationAdded:
            self = .outputTextAnnotationAdded(try OutputTextAnnotationAdded(from: decoder))

        case .responseQueued:
            self = .responseQueued(try ResponseQueued(from: decoder))

        case .error:
            self = .error(try ErrorEvent(from: decoder))

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Event type \(typeString) parsing not yet implemented"
            )
        }
    }

    public var type: OpenAIResponseStreamEventType {
        switch self {
        case .responseCreated: return .responseCreated
        case .responseInProgress: return .responseInProgress
        case .responseCompleted: return .responseCompleted
        case .responseFailed: return .responseFailed
        case .responseIncomplete: return .responseIncomplete
        case .outputItemAdded: return .responseOutputItemAdded
        case .outputItemDone: return .responseOutputItemDone
        case .contentPartAdded: return .responseContentPartAdded
        case .contentPartDone: return .responseContentPartDone
        case .outputTextDelta: return .responseOutputTextDelta
        case .outputTextDone: return .responseOutputTextDone
        case .outputTextAnnotationAdded: return .responseOutputTextAnnotationAdded
        case .refusalDelta: return .responseRefusalDelta
        case .refusalDone: return .responseRefusalDone
        case .functionCallArgumentsDelta: return .responseFunctionCallArgumentsDelta
        case .functionCallArgumentsDone: return .responseFunctionCallArgumentsDone
        case .fileSearchCallInProgress: return .responseFileSearchCallInProgress
        case .fileSearchCallSearching: return .responseFileSearchCallSearching
        case .fileSearchCallCompleted: return .responseFileSearchCallCompleted
        case .webSearchCallInProgress: return .responseWebSearchCallInProgress
        case .webSearchCallSearching: return .responseWebSearchCallSearching
        case .webSearchCallCompleted: return .responseWebSearchCallCompleted
        case .audioDelta: return .responseReasoningDelta // not ideal but no dedicated type
        case .audioDone: return .responseReasoningDelta
        case .audioTranscriptDelta: return .responseReasoningDelta
        case .audioTranscriptDone: return .responseReasoningDelta
        case .codeInterpreterCallProgress: return .responseReasoningDelta
        case .computerCallProgress: return .responseReasoningDelta
        case .reasoningDelta: return .responseReasoningDelta
        case .reasoningDone: return .responseReasoningDone
        case .reasoningSummaryPartAdded: return .responseReasoningSummaryPartAdded
        case .reasoningSummaryPartDone: return .responseReasoningSummaryPartDone
        case .reasoningSummaryTextDelta: return .responseReasoningSummaryTextDelta
        case .reasoningSummaryTextDone: return .responseReasoningSummaryTextDone
        case .reasoningSummaryDelta: return .responseReasoningSummaryDelta
        case .reasoningSummaryDone: return .responseReasoningSummaryDone
        case .imageGenerationCallProgress: return .responseImageGenerationCallInProgress
        case .imageGenerationCallPartialImage: return .responseImageGenerationCallPartialImage
        case .mcpCallArgumentsDelta: return .responseMcpCallArgumentsDelta
        case .mcpCallArgumentsDone: return .responseMcpCallArgumentsDone
        case .mcpCallProgress: return .responseMcpCallCompleted
        case .mcpListToolsProgress: return .responseMcpListToolsCompleted
        case .responseQueued: return .responseQueued
        case .error: return .error
        }
    }

}

// MARK: - Response Lifecycle Events
extension OpenAIResponseStreamingEvent {
    public struct ResponseCreated: Decodable {
        public let response: OpenAIResponse
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case response
            case sequenceNumber = "sequence_number"
        }
    }

    // Dead code?
//    public struct ReasoningData: Decodable {
//        public let effort: String?
//        public let summary: String?
//    }

//    public struct TextFormat: Decodable {
//        public let format: FormatType
//
//        public struct FormatType: Decodable {
//            public let type: String
//            public let description: String?
//            public let name: String?
//            public let schema: AIProxyJSONValue?
//            public let strict: Bool?
//
//            private enum CodingKeys: String, CodingKey {
//                case type, description, name, schema, strict
//            }
//        }
//    }

    public struct ResponseInProgress: Decodable {
        public let response: OpenAIResponse
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case response
            case sequenceNumber = "sequence_number"
        }
    }

    public struct ResponseCompleted: Decodable {
        public let response: OpenAIResponse
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case response
            case sequenceNumber = "sequence_number"
        }
    }

    public struct ResponseFailed: Decodable {
        public let response: OpenAIResponse
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case response
            case sequenceNumber = "sequence_number"
        }
    }

    public struct ResponseIncomplete: Decodable {
        public let response: OpenAIResponse
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case response
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Output Item Events
extension OpenAIResponseStreamingEvent {

    /// Represents `response.output_item.added`
    /// https://platform.openai.com/docs/api-reference/responses-streaming/response/output_item/added
    public struct OutputItemAdded: Decodable {
        public let sequenceNumber: Int?
        public let index: Int?

        // This should be an enum:
        public let item: OpenAIResponse.ResponseOutputItem

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case index = "output_index"
            case item
        }
    }

    public struct OutputItemDone: Decodable {
        public let item: OpenAIResponse.ResponseOutputItem
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case item
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Content Part Events
extension OpenAIResponseStreamingEvent {
    /// Representation of `response.content_part.added`
    /// https://platform.openai.com/docs/api-reference/responses-streaming/response/content_part/added
    public struct ContentPartAdded: Decodable {
        /// The sequence number of this event.
        public let sequenceNumber: Int?

        /// The index of the content part that was added.
        public let contentIndex: Int?

        /// The index of the output item that the content part was added to.
        public let outputIndex: Int?

        /// The content part that was added.
        public let part: OpenAIResponse.Content

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case contentIndex = "content_index"
            case outputIndex = "output_index"
            case part
        }
    }

    public struct ContentPartDone: Decodable {
        public let contentIndex: Int?
        public let itemID: String?
        public let outputIndex: Int?
        public let part: OpenAIResponse.Content
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case contentIndex = "content_index"
            case itemID = "item_id"
            case outputIndex = "output_index"
            case part
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Text Events
extension OpenAIResponseStreamingEvent {
    /// https://platform.openai.com/docs/api-reference/responses-streaming/response/output_text/delta
    public struct OutputTextDelta: Decodable {
        /// The index of the content part that the text delta was added to.
        public let contentIndex: Int?

        /// The text delta that was added.
        public let delta: String

        /// The ID of the output item that the text delta was added to.
        public let itemID: String?

        /// The index of the output item that the text delta was added to.
        public let outputIndex: Int?

        /// The sequence number for this event.
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case contentIndex = "content_index"
            case delta
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.output_text.annotation.added`
    public struct OutputTextAnnotationAdded: Decodable {
        public let sequenceNumber: Int?
        public let itemID: String?
        public let outputIndex: Int?
        public let contentIndex: Int?
        public let annotationIndex: Int?
        public let annotation: OpenAIResponse.Annotation?

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case itemID = "item_id"
            case outputIndex = "output_index"
            case contentIndex = "content_index"
            case annotationIndex = "annotation_index"
            case annotation
        }
    }

    public struct OutputTextDone: Decodable {
        public let contentIndex: Int?
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?
        public let text: String

        private enum CodingKeys: String, CodingKey {
            case contentIndex = "content_index"
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
            case text
        }
    }
}

// MARK: - Refusal Events
extension OpenAIResponseStreamingEvent {
    public struct RefusalDelta: Decodable {
        public let contentIndex: Int?
        public let delta: String
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case contentIndex = "content_index"
            case delta
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    public struct RefusalDone: Decodable {
        public let contentIndex: Int?
        public let itemID: String?
        public let outputIndex: Int?
        public let refusal: String
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case contentIndex = "content_index"
            case itemID = "item_id"
            case outputIndex = "output_index"
            case refusal
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Function Call Events
extension OpenAIResponseStreamingEvent {
    /// https://platform.openai.com/docs/api-reference/responses-streaming/response/function_call_arguments/delta
    public struct FunctionCallArgumentsDelta: Decodable {
        ///  The function-call arguments delta that is added.
        public let delta: String

        /// The ID of the output item that the function-call arguments delta is added to.
        public let itemID: String?

        /// The index of the output item that the function-call arguments delta is added to.
        public let outputIndex: Int?

        /// The sequence number of this event.
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case delta
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    public struct FunctionCallArgumentsDone: Decodable {
        ///  The function-call arguments delta that is added.
        public let arguments: String

        /// The ID of the output item that the function-call arguments delta is added to.
        public let itemID: String?

        /// The index of the output item that the function-call arguments delta is added to.
        public let outputIndex: Int?

        /// The sequence number of this event.
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case arguments
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Search Call Events
extension OpenAIResponseStreamingEvent {
    /// Represents `response.file_search_call.in_progress`
    public struct FileSearchCallInProgress: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.file_search_call.searching`
    public struct FileSearchCallSearching: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.file_search_call.completed`
    public struct FileSearchCallCompleted: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.web_search_call.in_progress`
    public struct WebSearchCallInProgress: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.web_search_call.searching`
    public struct WebSearchCallSearching: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }

    /// Represents `response.web_search_call.completed`
    public struct WebSearchCallCompleted: Decodable {
        public let itemID: String?
        public let outputIndex: Int?
        public let sequenceNumber: Int?

        private enum CodingKeys: String, CodingKey {
            case itemID = "item_id"
            case outputIndex = "output_index"
            case sequenceNumber = "sequence_number"
        }
    }
}

// MARK: - Audio Events
extension OpenAIResponseStreamingEvent {
    public struct AudioDelta: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String // Base64 encoded audio data

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }

    public struct AudioDone: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let contentPartIndex: Int

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
        }
    }

    public struct AudioTranscriptDelta: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let delta: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case delta
        }
    }

    public struct AudioTranscriptDone: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let contentPartIndex: Int
        public let transcript: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case contentPartIndex = "content_part_index"
            case transcript
        }
    }
}

// MARK: - Code Interpreter and Computer Call Events
extension OpenAIResponseStreamingEvent {
    public struct CodeInterpreterCallProgress: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let id: String
        public let status: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case id
            case status
        }
    }

    public struct ComputerCallProgress: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let id: String
        public let callId: String
        public let status: String
        public let action: OpenAIResponse.ComputerAction?
        public let pendingSafetyChecks: [OpenAIResponse.SafetyCheck]?

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
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
    public struct ReasoningDelta: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let delta: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputItemIndex = "output_item_index"
            case delta
        }
    }

    public struct ReasoningDone: Decodable {
        public let sequenceNumber: Int
        public let outputItemIndex: Int
        public let reasoning: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
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

    public struct ReasoningSummaryPartAdded: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: ReasoningSummaryPart

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case part
        }
    }

    public struct ReasoningSummaryPartDone: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: ReasoningSummaryPart

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case part
        }
    }

    public struct ReasoningSummaryTextDelta: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let delta: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case delta
        }
    }

    public struct ReasoningSummaryTextDone: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let text: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case text
        }
    }

    public struct ReasoningSummaryDelta: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let delta: AIProxyJSONValue

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case delta
        }
    }

    public struct ReasoningSummaryDone: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let summaryIndex: Int
        public let text: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case summaryIndex = "summary_index"
            case text
        }
    }
}

// MARK: - Image Generation Events
extension OpenAIResponseStreamingEvent {
    public struct ImageGenerationCallProgress: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let status: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case status
        }
    }

    public struct ImageGenerationCallPartialImage: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let partialImageIndex: Int
        public let partialImageB64: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case partialImageIndex = "partial_image_index"
            case partialImageB64 = "partial_image_b64"
        }
    }
}

// MARK: - MCP Call Events
extension OpenAIResponseStreamingEvent {
    public struct McpCallArgumentsDelta: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let delta: AIProxyJSONValue

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case delta
        }
    }

    public struct McpCallArgumentsDone: Decodable {
        public let sequenceNumber: Int
        public let outputIndex: Int
        public let arguments: AIProxyJSONValue

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case outputIndex = "output_index"
            case arguments
        }
    }

    public struct McpCallProgress: Decodable {
        public let sequenceNumber: Int
        public let status: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case status
        }
    }

    public struct McpListToolsProgress: Decodable {
        public let sequenceNumber: Int
        public let status: String

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case status
        }
    }
}


// MARK: - Response Queue Events
extension OpenAIResponseStreamingEvent {
    public struct ResponseQueued: Decodable {
        public let sequenceNumber: Int
        public let response: AIProxyJSONValue

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case response
        }
    }
}

// MARK: - Error Events
extension OpenAIResponseStreamingEvent {
    public struct ErrorEvent: Decodable {
        public let sequenceNumber: Int
        public let code: String
        public let message: String
        public let param: String?

        private enum CodingKeys: String, CodingKey {
            case sequenceNumber = "sequence_number"
            case code
            case message
            case param
        }
    }
}
