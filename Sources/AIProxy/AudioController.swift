//
//  AudioController.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

import AVFoundation

@RealtimeActor
open class AudioController {
    private let audioEngine: AVAudioEngine
    private let microphonePCMSampleVendor: MicrophonePCMSampleVendor
    private var audioPCMPlayer: AudioPCMPlayer

    @RealtimeActor
    public init() async throws {
        #if os(iOS)
        // This is not respected if `setVoiceProcessingEnabled(true)` is used :/
        // Instead, I've added my own accumulator.
        // try? AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.1)
        // print("I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)
        try? AVAudioSession.sharedInstance().setCategory(
            .playAndRecord,
            mode: .voiceChat,
            options: [.defaultToSpeaker, .allowBluetooth]
        )
        try? AVAudioSession.sharedInstance().setActive(true, options: [])

        #elseif os(watchOS)
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try? await AVAudioSession.sharedInstance().activate(options: [])
        #endif

        self.audioEngine = AVAudioEngine()

        #if os(macOS) || os(iOS)
        self.microphonePCMSampleVendor = AIProxyUtils.headphonesConnected
                                           ? try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
                                           : MicrophonePCMSampleVendorAT()
        #else
        self.microphonePCMSampleVendor = try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
        #endif

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
