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
// If you use this, and initialize the MicrophonePCMSampleVendor *after* AudioPCMPlayer,
// then audio on iOS will be very loud. You can dial it down a bit by adjusting the gain
// in `playPCM16Audio` below
        //try? AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.1) //// This is not respected if `setVoiceProcessingEnabled(true)` is used :/
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)
try? AVAudioSession.sharedInstance().setCategory(
    .playAndRecord,
    mode: .voiceChat,
    options: [.defaultToSpeaker, .allowBluetooth]
)
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)

#elseif os(watchOS)
try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
try? await AVAudioSession.sharedInstance().activate(options: [])
#endif

        self.audioEngine = AVAudioEngine()
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)


        #if os(macOS) || os(iOS)
        self.microphonePCMSampleVendor = AIProxyUtils.headphonesConnected
                                           ? try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
                                           : MicrophonePCMSampleVendorAT()
        #else
        self.microphonePCMSampleVendor = try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
        #endif
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)


        self.audioPCMPlayer = await try AudioPCMPlayer(audioEngine: self.audioEngine)
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)


        self.audioEngine.prepare()
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)
        try self.audioEngine.start()
        print("Actual I/O buffer duration:", AVAudioSession.sharedInstance().ioBufferDuration)
    }

    public func micStream() throws -> AsyncStream<AVAudioPCMBuffer> {
        return try self.microphonePCMSampleVendor.start()
    }

    public func stop() {
        self.microphonePCMSampleVendor.stop()
        self.audioPCMPlayer.interruptPlayback()
    }

    public func playPCM16Audio(from base64String: String) {
        print("Trying to play")
        self.audioPCMPlayer.playPCM16Audio(from: base64String)
    }

    public func interruptPlayback() {
        self.audioPCMPlayer.interruptPlayback()
    }
}
