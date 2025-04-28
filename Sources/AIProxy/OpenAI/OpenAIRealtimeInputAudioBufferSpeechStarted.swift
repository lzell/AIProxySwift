//
//  OpenAIRealtimeInputAudioBufferSpeechStarted.swift
//
//
//  Created by Lou Zell on 11/4/24.
//

import Foundation

/// This is not actually used! I'm not using decodable for this event, just inspecting the 'type' string
/// This is sent from server to client when vad detects that speech started.
public struct OpenAIRealtimeInputAudioBufferSpeechStarted: Decodable {
    public let type = "input_audio_buffer.speech_started"
    public let audioStartMs: Int

    private enum CodingKeys: String, CodingKey {
        case audioStartMs = "audio_start_ms"
    }
}
