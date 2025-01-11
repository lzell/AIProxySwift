//
//  OpenAIRealtimeMessage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/29/24.
//

public enum OpenAIRealtimeMessage {
    case responseAudioDelta(String) // = "response.audio.delta" //OpenAIRealtimeResponseAudioDelta)
    case sessionUpdated // = "session.updated"// OpenAIRealtimeSessionUpdated
    case inputAudioBufferSpeechStarted // = "input_audio_buffer.speech_started"
    case sessionCreated //= "session.created"
}
