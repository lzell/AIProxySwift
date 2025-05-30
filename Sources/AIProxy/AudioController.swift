//
//  AudioController.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

import AVFoundation

@RealtimeActor
open class AudioController {
    private let useAudioToolbox: Bool
    private let audioEngine = AVAudioEngine()
    private let microphonePCMSampleVendor: MicrophonePCMSampleVendor
    private var audioPCMPlayer: AudioPCMPlayer

    @RealtimeActor
    public init() async throws {
        #if os(macOS)
        useAudioToolbox = !AIProxyUtils.headphonesConnected
        #else
        useAudioToolbox = false
        #endif

        if useAudioToolbox {
            self.microphonePCMSampleVendor = MicrophonePCMSampleVendorAT()
        } else {
            self.microphonePCMSampleVendor = try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
        }

        self.audioPCMPlayer = await try AudioPCMPlayer(audioEngine: self.audioEngine)
        self.audioEngine.prepare()
        try self.audioEngine.start()
    }

    public func micStream() throws -> AsyncStream<AVAudioPCMBuffer> {
        return try self.microphonePCMSampleVendor.start()
    }

    public func stop() {
        self.microphonePCMSampleVendor.stop()
        self.audioPCMPlayer.interruptPlayback()
    }

    public func playPCM16Audio(from base64String: String) {
        self.audioPCMPlayer.playPCM16Audio(from: base64String)
    }

    public func interruptPlayback() {
        self.audioPCMPlayer.interruptPlayback()
    }
}
