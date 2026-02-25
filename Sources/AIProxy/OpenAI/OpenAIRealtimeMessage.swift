//
//  OpenAIRealtimeMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/29/24.
//  Update by harr-sudo 05/05/2025

nonisolated public enum OpenAIRealtimeMessage: Sendable {
    case error(OpenAIRealtimeErrorEvent)
    case sessionCreated // "session.created"
    case sessionUpdated // "session.updated"
    case responseCreated(OpenAIRealtimeResponseCreatedEvent) // "response.created"
    case responseAudioDelta(OpenAIRealtimeResponseAudioDeltaEvent) // "response.audio.delta"
    case inputAudioBufferSpeechStarted(OpenAIRealtimeInputAudioBufferSpeechStartedEvent) // "input_audio_buffer.speech_started"
    case inputAudioBufferSpeechStopped(OpenAIRealtimeInputAudioBufferSpeechStoppedEvent) // "input_audio_buffer.speech_stopped"
    case inputAudioBufferCommitted(OpenAIRealtimeInputAudioBufferCommittedEvent) // "input_audio_buffer.committed"
    case conversationItemCreated(OpenAIRealtimeConversationItemCreatedEvent) // "conversation.item.created"
    case responseFunctionCallArgumentsDone(OpenAIRealtimeResponseFunctionCallArgumentsDoneEvent) // "response.function_call_arguments.done"
    case responseOutputItemAdded(OpenAIRealtimeResponseOutputItemAddedEvent) // "response.output_item.added"
    case responseOutputItemDone(OpenAIRealtimeResponseOutputItemDoneEvent) // "response.output_item.done"
    case responseContentPartAdded(OpenAIRealtimeResponseContentPartAddedEvent) // "response.content_part.added"
    case responseContentPartDone(OpenAIRealtimeResponseContentPartDoneEvent) // "response.content_part.done"
    case responseAudioDone(OpenAIRealtimeResponseAudioDoneEvent) // "response.audio.done" / "response.output_audio.done"
    case responseDone(OpenAIRealtimeResponseDoneEvent) // "response.done"
    case rateLimitsUpdated(OpenAIRealtimeRateLimitsUpdatedEvent) // "rate_limits.updated"
    
    case responseTranscriptDelta(OpenAIRealtimeResponseTranscriptDeltaEvent) // "response.audio_transcript.delta" / "response.output_audio_transcript.delta"
    case responseTranscriptDone(OpenAIRealtimeResponseTranscriptDoneEvent) // "response.audio_transcript.done" / "response.output_audio_transcript.done"
    case inputAudioBufferTranscript(OpenAIRealtimeInputAudioBufferTranscriptEvent) // "input_audio_buffer.transcript"
    case inputAudioTranscriptionDelta(OpenAIRealtimeInputAudioTranscriptionDeltaEvent) // "conversation.item.input_audio_transcription.delta"
    case inputAudioTranscriptionCompleted(OpenAIRealtimeInputAudioTranscriptionCompletedEvent) // "conversation.item.input_audio_transcription.completed"
}

public struct OpenAIRealtimeErrorEvent: Sendable {
    public let errorBody: String?
}

public struct OpenAIRealtimeResponseCreatedEvent: Sendable {
    public let responseID: String?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseAudioDeltaEvent: Sendable {
    public let base64Audio: String
}

public struct OpenAIRealtimeInputAudioBufferSpeechStartedEvent: Sendable {
    public let itemID: String?
    public let audioStartMS: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeInputAudioBufferSpeechStoppedEvent: Sendable {
    public let itemID: String?
    public let audioEndMS: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeInputAudioBufferCommittedEvent: Sendable {
    public let itemID: String?
    public let previousItemID: String?
    public let eventID: String?
}

public struct OpenAIRealtimeConversationItemCreatedEvent: Sendable {
    public let itemID: String?
    public let previousItemID: String?
    public let role: String?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseFunctionCallArgumentsDoneEvent: Sendable {
    public let name: String
    public let arguments: String
    public let callID: String
}

public struct OpenAIRealtimeResponseOutputItemAddedEvent: Sendable {
    public let responseID: String?
    public let itemID: String?
    public let outputIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseOutputItemDoneEvent: Sendable {
    public let responseID: String?
    public let itemID: String?
    public let outputIndex: Int?
    public let transcript: String?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseContentPartAddedEvent: Sendable {
    public let responseID: String?
    public let itemID: String?
    public let outputIndex: Int?
    public let contentIndex: Int?
    public let part: OpenAIRealtimeContentPart?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseContentPartDoneEvent: Sendable {
    public let responseID: String?
    public let itemID: String?
    public let outputIndex: Int?
    public let contentIndex: Int?
    public let transcript: String?
    public let part: OpenAIRealtimeContentPart?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseAudioDoneEvent: Sendable {
    public let responseID: String?
    public let itemID: String?
    public let outputIndex: Int?
    public let contentIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseDoneEvent: Sendable {
    public let responseID: String?
    public let conversationID: String?
    public let status: String?
    public let eventID: String?
}

public struct OpenAIRealtimeRateLimitsUpdatedEvent: Sendable {
    public let rateLimits: [OpenAIRealtimeRateLimit]
    public let eventID: String?
}

public struct OpenAIRealtimeResponseTranscriptDeltaEvent: Sendable {
    public let delta: String
    public let responseID: String?
    public let itemID: String?
    public let contentIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeResponseTranscriptDoneEvent: Sendable {
    public let transcript: String
    public let responseID: String?
    public let itemID: String?
    public let contentIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeInputAudioBufferTranscriptEvent: Sendable {
    public let transcript: String
}

public struct OpenAIRealtimeInputAudioTranscriptionDeltaEvent: Sendable {
    public let delta: String
    public let itemID: String?
    public let contentIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeInputAudioTranscriptionCompletedEvent: Sendable {
    public let transcript: String
    public let itemID: String?
    public let contentIndex: Int?
    public let eventID: String?
}

public struct OpenAIRealtimeContentPart: Sendable {
    public let type: String?
    public let audio: String?
    public let text: String?
    public let transcript: String?
}

public struct OpenAIRealtimeRateLimit: Sendable {
    public let name: String?
    public let limit: Int?
    public let remaining: Int?
    public let resetSeconds: Double?
}
