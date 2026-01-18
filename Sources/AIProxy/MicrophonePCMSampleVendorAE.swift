//
//  MicrophonePCMSampleVendorAE.swift
//  AIProxy
//
//  Created by Lou Zell
//

@preconcurrency import AVFoundation
import Foundation

/// This is an AVAudioEngine-based implementation that vends PCM16 microphone samples.
///
/// ## Requirements
///
/// - Assumes an `NSMicrophoneUsageDescription` description has been added to Target > Info
/// - Assumes that microphone permissions have already been granted
///
/// #Usage
///
///     ```
///     let microphoneVendor = try MicrophonePCMSampleVendorAE()
///     let micStream = try microphoneVendor.start()
///     Task {
///         for await buffer in micStream {
///             // Use buffer
///         }
///     }
///     // ... some time later ...
///     microphoneVendor.stop()
///     ```
///
/// References:
/// Apple sample code: https://developer.apple.com/documentation/avfaudio/using-voice-processing
/// Apple technical note: https://developer.apple.com/documentation/technotes/tn3136-avaudioconverter-performing-sample-rate-conversions
/// My apple forum question: https://developer.apple.com/forums/thread/771530
@AIProxyActor class MicrophonePCMSampleVendorAE: MicrophonePCMSampleVendor {
    private let audioEngine: AVAudioEngine
    private let inputNode: AVAudioInputNode
    private let microphonePCMSampleVendorCommon = MicrophonePCMSampleVendorCommon()
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?

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
        //
        // Try to get 50ms updates.
        // 50ms is half the granularity of our target accumulator (we accumulate into 100ms payloads that we send up to OpenAI)
        //
        // There is a note on the installTap documentation that says AudioEngine may
        // adjust the bufferSize internally.
        let targetBufferSize = UInt32(desiredTapFormat.sampleRate / 20) // 50ms buffers
        logIf(.error)?.error("PCMSampleVendorAE target buffer size is: \(targetBufferSize)")

        return AsyncStream<AVAudioPCMBuffer> { [weak self] continuation in
            guard let this = self else { return }
            this.continuation = continuation

            // This ensures the closure created is NOT actor-isolated.
            // See PR https://github.com/lzell/AIProxySwift/pull/238 for more.
            this.installTapNonIsolated(
                inputNode: this.inputNode,
                bufferSize: targetBufferSize,
                format: desiredTapFormat
            )
        }
    }

    nonisolated private func installTapNonIsolated(
        inputNode: AVAudioInputNode,
        bufferSize: AVAudioFrameCount,
        format: AVAudioFormat
    ) {
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: format) { [weak self] sampleBuffer, _ in
            guard let self else { return }
            Task {
                await self.processBuffer(sampleBuffer)
            }
        }
    }

    private func processBuffer(_ buffer: AVAudioPCMBuffer) {
        // This runs on the actor, so we can safely access isolated properties.
        if let accumulatedBuffer = self.microphonePCMSampleVendorCommon.resampleAndAccumulate(buffer) {
            self.continuation?.yield(accumulatedBuffer)
        }
    }

    func stop() {
        self.continuation?.finish()
        self.continuation = nil
        inputNode.removeTap(onBus: 0)
        try? inputNode.setVoiceProcessingEnabled(false)
        microphonePCMSampleVendorCommon.audioConverter = nil
    }
}
