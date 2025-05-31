//
//  AudioController.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

import AVFoundation

/// Use this class to control the streaming of mic data and playback of PCM16 data.
/// Audio played using the `playPCM16Audio` method does not interfere with the mic data streaming out of the `micStream` AsyncStream.
/// That is, if you use this to control audio in an OpenAI realtime session, the model will not hear itself.
///
/// For a usage example, see the OpenAI realtime snippet here:
/// https://github.com/lzell/AIProxySwift#how-use-realtime-audio-with-openai
///
/// ## Implementor's note
/// We use either AVAudioEngine or AudioToolbox for mic data, depending on the platform and whether headphones are attached.
/// The following arrangement provides for the best user experience:
///
///     +----------+---------------+------------------+
///     | Platform | Headphones    | Audio API        |
///     +----------+---------------+------------------+
///     | macOS    | Yes           | AudioEngine      |
///     | macOS    | No            | AudioToolbox     |
///     | iOS      | Yes           | AudioEngine      |
///     | iOS      | No            | AudioToolbox     |
///     | watchOS  | Yes           | AudioEngine      |
///     | watchOS  | No            | AudioEngine      |
///     +----------+---------------+------------------+
///
@RealtimeActor
open class AudioController {
    public enum Mode {
        case record
        case playback
    }
    public let modes: [Mode]
    private let audioEngine: AVAudioEngine
    private var microphonePCMSampleVendor: MicrophonePCMSampleVendor? = nil
    private var audioPCMPlayer: AudioPCMPlayer? = nil

    @RealtimeActor
    public init(modes: [Mode]) async throws {
        self.modes = modes
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

        if modes.contains(.record) {
            #if os(macOS) || os(iOS)
            self.microphonePCMSampleVendor = AIProxyUtils.headphonesConnected
                                               ? try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
                                               : MicrophonePCMSampleVendorAT()
            #else
            self.microphonePCMSampleVendor = try MicrophonePCMSampleVendorAE(audioEngine: self.audioEngine)
            #endif
        }


        if modes.contains(.playback) {
            self.audioPCMPlayer = try await AudioPCMPlayer(audioEngine: self.audioEngine)
        }

        self.audioEngine.prepare()

        // Nesting `start` in a Task is necessary on watchOS.
        // There is some sort of race, and letting the runloop tick seems to "fix" it.
        // If I call `prepare` and `start` in serial succession, then there is no playback on watchOS (sometimes).
        Task {
            try self.audioEngine.start()
        }
    }

    public func micStream() throws -> AsyncStream<AVAudioPCMBuffer> {
        guard self.modes.contains(.record),
              let microphonePCMSampleVendor = self.microphonePCMSampleVendor else {
            throw AIProxyError.assertion("Please pass [.record] to the AudioController initializer")
        }
        return try microphonePCMSampleVendor.start()
    }

    public func stop() {
        self.microphonePCMSampleVendor?.stop()
        self.audioPCMPlayer?.interruptPlayback()
    }

    public func playPCM16Audio(base64String: String) {
        guard self.modes.contains(.playback),
              let audioPCMPlayer = self.audioPCMPlayer else {
            logIf(.error)?.error("Please pass [.playback] to the AudioController initializer")
            return
        }
        audioPCMPlayer.playPCM16Audio(from: base64String)
    }

    public func interruptPlayback() {
        guard self.modes.contains(.playback),
              let audioPCMPlayer = self.audioPCMPlayer else {
            logIf(.error)?.error("Please pass [.playback] to the AudioController initializer")
            return
        }
        audioPCMPlayer.interruptPlayback()
    }
}
