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
    case responseCreated(responseId: String?) // "response.created"
    case responseAudioDelta(String) // "response.audio.delta"
    case inputAudioBufferSpeechStarted(itemId: String?) // "input_audio_buffer.speech_started"
    case inputAudioBufferSpeechStopped(itemId: String?, audioEndMs: Int?) // "input_audio_buffer.speech_stopped"
    case inputAudioBufferCommitted(itemId: String?, previousItemId: String?) // "input_audio_buffer.committed"
    case conversationItemCreated(itemId: String?, previousItemId: String?, role: String?) // "conversation.item.created"
    case responseFunctionCallArgumentsDone(String, String, String) // "response.function_call_arguments.done"
    case responseOutputItemAdded(responseId: String?, itemId: String?, outputIndex: Int?) // "response.output_item.added"
    case responseOutputItemDone(responseId: String?, itemId: String?, outputIndex: Int?, transcript: String?) // "response.output_item.done"
    case responseContentPartAdded(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?) // "response.content_part.added"
    case responseContentPartDone(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?, transcript: String?) // "response.content_part.done"
    case responseAudioDone(responseId: String?, itemId: String?, outputIndex: Int?, contentIndex: Int?) // "response.audio.done"
    case responseDone(responseId: String?, conversationId: String?) // "response.done"
    case rateLimitsUpdated // "rate_limits.updated"
    
    // Add new cases for transcription
    case responseTranscriptDelta(String, responseId: String?, itemId: String?) // "response.audio_transcript.delta"
    case responseTranscriptDone(String, responseId: String?, itemId: String?) // "response.audio_transcript.done"
    case inputAudioBufferTranscript(String) // "input_audio_buffer.transcript"
    case inputAudioTranscriptionDelta(String, itemId: String?) // "conversation.item.input_audio_transcription.delta"
    case inputAudioTranscriptionCompleted(String, itemId: String?) // "conversation.item.input_audio_transcription.completed"
}
