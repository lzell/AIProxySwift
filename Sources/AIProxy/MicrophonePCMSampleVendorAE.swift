//
//  MicrophonePCMSampleVendorAE.swift
//  AIProxy
//
//  Created by Lou Zell
//

import AVFoundation
import Foundation

/// This is an AVAudioEngine-based implementation that vends PCM16 microphone samples.
///
/// ## Requirements
///
/// - Assumes an `NSMicrophoneUsageDescription` description has been added to Target > Info
/// - Assumes that microphone permissions have already been granted
///
/// ## Usage
///
/// ```
///     let microphoneVendor = try MicrophonePCMSampleVendor()
///     microphoneVendor.start { sample in
///        // Do something with `sample`
///        // Note: this callback is invoked on a background thread
///     }
/// ```
///
///
/// References:
/// Apple sample code: https://developer.apple.com/documentation/avfaudio/using-voice-processing
/// Apple technical note: https://developer.apple.com/documentation/technotes/tn3136-avaudioconverter-performing-sample-rate-conversions
/// My apple forum question: https://developer.apple.com/forums/thread/771530
@RealtimeActor
final class MicrophonePCMSampleVendorAE: MicrophonePCMSampleVendor {
    private let audioEngine: AVAudioEngine
    private let inputNode: AVAudioInputNode
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?

    internal var audioConverter: AVAudioConverter?  // MicrophonePCMSampleVendor conformance
    internal func setAudioConverter(_ audioConverter: AVAudioConverter?) {
        self.audioConverter = audioConverter
    }

    init(audioEngine: AVAudioEngine) throws {
        self.audioEngine = audioEngine
        self.inputNode = self.audioEngine.inputNode

        if !AIProxyUtils.headphonesConnected {
            try self.inputNode.setVoiceProcessingEnabled(true)
        }

        logIf(.debug)?.debug("""
            Using AudioEngine based PCM sample vendor.
            The input node's input format is: \(self.inputNode.inputFormat(forBus: 0))
            The input node's output format is: \(self.inputNode.outputFormat(forBus: 0))
            """)
    }

    deinit {
        logIf(.debug)?.debug("MicrophonePCMSampleVendorAE is being freed")
    }


    public func start() throws -> AsyncStream<AVAudioPCMBuffer> {
        guard let desiredTapFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: inputNode.outputFormat(forBus: 0).sampleRate, // self.inputNode.inputFormat(forBus: 0).sampleRate ,
            channels: 1,
            interleaved: false
        ) else {
            throw AIProxyError.assertion("Could not create the desired tap format for realtime")
        }

        // The buffer size argument specifies the target number of audio frames.
        // For a single channel, a single audio frame has a single audio sample.
        // So we are shooting for 1 sample every 100 ms with this calulation.
        //
        // There is a note on the installTap documentation that says AudioEngine may
        // adjust the bufferSize internally.
        let targetBufferSize = UInt32(desiredTapFormat.sampleRate / 10)

        return AsyncStream<AVAudioPCMBuffer> { [weak self] continuation in
            guard let this = self else { return }
            this.continuation = continuation
            this.inputNode.installTap(onBus: 0, bufferSize: targetBufferSize, format: desiredTapFormat) { [weak this] sampleBuffer, _ in
                if let resampledBuffer = self?.convertPCM16BufferToExpectedSampleRate(sampleBuffer) {
                    this?.continuation?.yield(resampledBuffer)
                }
            }
        }
    }

    func stop() {
        self.continuation?.finish()
        self.continuation = nil
        inputNode.removeTap(onBus: 0)
        try? inputNode.setVoiceProcessingEnabled(false)
        audioConverter = nil
    }
}
