//
//  OpenAIResponseStreamingChunk.swift
//  AIProxy
//
//  Created by Matt Corey on 6/21/25.
//

import Foundation

/// Represents a streamed chunk of a response returned by the OpenAI Responses API
/// https://platform.openai.com/docs/api-reference/responses-streaming
public struct OpenAIResponseStreamingChunk: Decodable {
    /// The streaming event contained in this chunk
    public let event: OpenAIResponseStreamingEvent
    
    /// Convenience accessor for the event type
    public var type: OpenAIResponseStreamEventType {
        return event.type
    }
    
    /// The unique identifier for the response (available in most events)
    public var responseId: String? {
        switch event.data {
        case .responseCreated(let data):
            return data.id
        case .responseInProgress(let data):
            return data.id
        case .responseCompleted(let data):
            return data.id
        case .responseFailed(let data):
            return data.id
        case .responseIncomplete(let data):
            return data.id
        default:
            return nil
        }
    }
    
    /// The model used for the response (only available in responseCreated event)
    public var model: String? {
        switch event.data {
        case .responseCreated(let data):
            return data.model
        default:
            return nil
        }
    }
    
    /// The status of the response (only available in responseCreated event)
    public var status: OpenAIResponse.Status? {
        switch event.data {
        case .responseCreated(let data):
            return data.status
        default:
            return nil
        }
    }
    
    /// Usage information (only available in responseCompleted event)
    public var usage: OpenAIResponse.ResponseUsage? {
        switch event.data {
        case .responseCompleted(let data):
            return data.usage
        default:
            return nil
        }
    }
    
    /// Error information (only available in responseFailed event)
    public var error: OpenAIResponse.ResponseError? {
        switch event.data {
        case .responseFailed(let data):
            return data.error
        default:
            return nil
        }
    }
    
    /// Text delta content (only available in outputTextDelta event)
    public var textDelta: String? {
        switch event.data {
        case .outputTextDelta(let data):
            return data.delta
        default:
            return nil
        }
    }
    
    /// Function call arguments delta (only available in functionCallArgumentsDelta event)
    public var functionArgumentsDelta: String? {
        switch event.data {
        case .functionCallArgumentsDelta(let data):
            return data.delta
        default:
            return nil
        }
    }
    
    /// Reasoning delta (only available in reasoningDelta event)
    public var reasoningDelta: String? {
        switch event.data {
        case .reasoningDelta(let data):
            return data.delta
        default:
            return nil
        }
    }
    
    /// Refusal delta (only available in refusalDelta event)
    public var refusalDelta: String? {
        switch event.data {
        case .refusalDelta(let data):
            return data.delta
        default:
            return nil
        }
    }
    
    /// Checks if this is a terminal event (completed, failed, or incomplete)
    public var isTerminal: Bool {
        switch event.type {
        case .responseCompleted, .responseFailed, .responseIncomplete:
            return true
        default:
            return false
        }
    }
    
    /// Checks if this is a delta event containing incremental content
    public var isDelta: Bool {
        switch event.type {
        case .responseOutputTextDelta,
             .responseFunctionCallArgumentsDelta,
             .responseReasoningDelta,
             .responseRefusalDelta:
            return true
        default:
            return false
        }
    }
    
    public init(from decoder: Decoder) throws {
        self.event = try OpenAIResponseStreamingEvent(from: decoder)
    }

}

// MARK: - Helper Methods
extension OpenAIResponseStreamingChunk {
    /// Extracts the output item index from events that contain it
    public var outputItemIndex: Int? {
        switch event.data {
        case .outputItemAdded(let data):
            return data.index
        case .outputItemDone(let data):
            return data.index
        case .contentPartAdded(let data):
            return data.outputItemIndex
        case .contentPartDone(let data):
            return data.outputItemIndex
        case .outputTextDelta(let data):
            return data.outputItemIndex
        case .outputTextAnnotationAdded(let data):
            return data.outputItemIndex
        case .outputTextDone(let data):
            return data.outputItemIndex
        case .refusalDelta(let data):
            return data.outputItemIndex
        case .refusalDone(let data):
            return data.outputItemIndex
        case .functionCallArgumentsDelta(let data):
            return data.outputItemIndex
        case .functionCallArgumentsDone(let data):
            return data.outputItemIndex
        case .fileSearchCallProgress(let data):
            return data.outputItemIndex
        case .webSearchCallProgress(let data):
            return data.outputItemIndex
        case .reasoningDelta(let data):
            return data.outputItemIndex
        case .reasoningDone(let data):
            return data.outputItemIndex
        default:
            return nil
        }
    }
    
    /// Extracts the content part index from events that contain it
    public var contentPartIndex: Int? {
        switch event.data {
        case .contentPartAdded(let data):
            return data.index
        case .contentPartDone(let data):
            return data.index
        case .outputTextDelta(let data):
            return data.contentPartIndex
        case .outputTextAnnotationAdded(let data):
            return data.contentPartIndex
        case .outputTextDone(let data):
            return data.contentPartIndex
        case .refusalDelta(let data):
            return data.contentPartIndex
        case .refusalDone(let data):
            return data.contentPartIndex
        default:
            return nil
        }
    }
}
