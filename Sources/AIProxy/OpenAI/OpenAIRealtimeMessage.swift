//
//  OpenAIRealtimeMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/29/24.
//  Update by harr-sudo 05/05/2025

nonisolated public enum OpenAIRealtimeMessage: Sendable {
    case error(String?)
    case sessionCreated // "session.created"
    case sessionUpdated // "session.updated"
    case responseCreated(responseId: String?, eventId: String?) // "response.created"
    case responseAudioDelta(String) // "response.audio.delta"
    case inputAudioBufferSpeechStarted(itemId: String?, audioStartMs: Int?, eventId: String?) // "input_audio_buffer.speech_started"
    case inputAudioBufferSpeechStopped(itemId: String?, audioEndMs: Int?, eventId: String?) // "input_audio_buffer.speech_stopped"
    case inputAudioBufferCommitted(itemId: String?, previousItemId: String?, eventId: String?) // "input_audio_buffer.committed"
    case conversationItemCreated(itemId: String?, previousItemId: String?, role: String?, eventId: String?) // "conversation.item.created"
    case responseFunctionCallArgumentsDone(String, String, String) // "response.function_call_arguments.done"
    case responseOutputItemAdded(responseId: String?, itemId: String?, outputIndex: Int?, eventId: String?) // "response.output_item.added"
    case responseOutputItemDone(responseId: String?, itemId: String?, outputIndex: Int?, transcript: String?, eventId: String?) // "response.output_item.done"
    case responseContentPartAdded(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?, part: OpenAIRealtimeContentPart?, eventId: String?) // "response.content_part.added"
    case responseContentPartDone(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?, transcript: String?, part: OpenAIRealtimeContentPart?, eventId: String?) // "response.content_part.done"
    case responseAudioDone(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?, eventId: String?) // "response.audio.done" / "response.output_audio.done"
    case responseDone(responseId: String?, conversationId: String?, status: String?, eventId: String?) // "response.done"
    case rateLimitsUpdated(rateLimits: [OpenAIRealtimeRateLimit], eventId: String?) // "rate_limits.updated"
    
    // Add new cases for transcription
    case responseTranscriptDelta(String, responseId: String?, itemId: String?, contentIndex: Int?, eventId: String?) // "response.audio_transcript.delta" / "response.output_audio_transcript.delta"
    case responseTranscriptDone(String, responseId: String?, itemId: String?, contentIndex: Int?, eventId: String?) // "response.audio_transcript.done" / "response.output_audio_transcript.done"
    case inputAudioBufferTranscript(String) // "input_audio_buffer.transcript"
    case inputAudioTranscriptionDelta(String, itemId: String?, contentIndex: Int?, eventId: String?) // "conversation.item.input_audio_transcription.delta"
    case inputAudioTranscriptionCompleted(String, itemId: String?, contentIndex: Int?, eventId: String?) // "conversation.item.input_audio_transcription.completed"
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
