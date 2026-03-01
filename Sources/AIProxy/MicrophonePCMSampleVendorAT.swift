//
//  MicrophonePCMSampleVendorAT.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

#if os(macOS) || os(iOS)

@preconcurrency import AVFoundation
import AudioToolbox
import Foundation

nonisolated private let kVoiceProcessingInputSampleRate: Double = 44100
nonisolated private let kEchoGuardOutputRMSFloor: Float = 0.0015
nonisolated private let kEchoGuardOutputTailSeconds: TimeInterval = 0.12
nonisolated private let kEchoGuardRMSSmoothingFactor: Float = 0.2
nonisolated private let kEchoGuardBargeInThresholdFloor: Float = 0.018
nonisolated private let kEchoGuardBargeInRelativeMultiplier: Float = 2.3
nonisolated private let kEchoGuardFramesForBargeIn = 2
nonisolated private let kEchoGuardBargeInHoldSeconds: TimeInterval = 1.0

/// This is an AudioToolbox-based implementation that vends PCM16 microphone samples at a
/// sample rate that OpenAI's realtime models expect.
///
/// ## Requirements
///
/// - Assumes an `NSMicrophoneUsageDescription` description has been added to Target > Info
/// - Assumes that microphone permissions have already been granted
///
/// ## Usage
///
///     ```
///     let microphoneVendor = MicrophonePCMSampleVendorAT()
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
///
/// ## References:
///
/// See the section "Essential Characteristics of I/O Units" here:
/// https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioUnitHostingGuide_iOS/AudioUnitHostingFundamentals/AudioUnitHostingFundamentals.html
///
/// See AudioUnit setup from these two obj-c projects:
/// https://developer.apple.com/library/archive/samplecode/aurioTouch/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007770
/// https://developer.apple.com/library/archive/samplecode/AVCaptureToAudioUnitOSX/Introduction/Intro.html#//apple_ref/doc/uid/DTS40012879
///
/// Apple technical note for performing audio conversions *when the sample rate is different*
/// https://developer.apple.com/documentation/technotes/tn3136-avaudioconverter-performing-sample-rate-conversions
///
/// This is an important answer to eliminate pops when using an AVAudioConverter:
/// https://stackoverflow.com/questions/64553738/avaudioconverter-corrupts-data
///
/// Apple sample code (Do not use this): https://developer.apple.com/documentation/avfaudio/using-voice-processing
/// My apple forum question (Do not use this): https://developer.apple.com/forums/thread/771530
@AIProxyActor class MicrophonePCMSampleVendorAT: MicrophonePCMSampleVendor {

    private var audioUnit: AudioUnit?
    private let microphonePCMSampleVendorCommon = MicrophonePCMSampleVendorCommon()
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?
    private var audioEngine: AVAudioEngine?
    private var outputLikelyActiveUntilUptime: TimeInterval = 0
    private var outputSmoothedRMS: Float = 0
    private var micLoudFrameStreak = 0
    private var bargeInOpenUntilUptime: TimeInterval = 0

    public init(audioEngine: AVAudioEngine? = nil) {
        self.audioEngine = audioEngine
    }

    deinit {
        logIf(.debug)?.debug("MicrophonePCMSampleVendor is being freed")
    }

    public func start() throws -> AsyncStream<AVAudioPCMBuffer> {
        var desc = AudioComponentDescription(
            componentType: kAudioUnitType_Output,
            componentSubType: kAudioUnitSubType_VoiceProcessingIO /* kAudioUnitSubType_RemoteIO */,
            componentManufacturer: kAudioUnitManufacturer_Apple,
            componentFlags: 0,
            componentFlagsMask: 0
        )

        guard let component = AudioComponentFindNext(nil, &desc) else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not find an audio component with VoiceProcessingIO"
            )
        }

        AudioComponentInstanceNew(component, &audioUnit)
        guard let audioUnit = audioUnit else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not instantiate an audio component with VoiceProcessingIO"
            )
        }

        var one: UInt32 = 1
        var err = AudioUnitSetProperty(audioUnit,
                                       kAudioOutputUnitProperty_EnableIO,
                                       kAudioUnitScope_Input,
                                       1,
                                       &one,
                                       UInt32(MemoryLayout.size(ofValue: one)))

        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not enable the input scope of the microphone bus"
            )
        }

        #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
        let shouldEnableSpeakerBusForAEC = audioEngine?.isInManualRenderingMode ?? false
        #else
        let shouldEnableSpeakerBusForAEC = true
        #endif
        var one_output: UInt32 = shouldEnableSpeakerBusForAEC ? 1 : 0
        err = AudioUnitSetProperty(audioUnit,
                                   kAudioOutputUnitProperty_EnableIO,
                                   kAudioUnitScope_Output,
                                   0,
                                   &one_output,
                                   UInt32(MemoryLayout.size(ofValue: one_output)))

        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not configure the output scope of the speaker bus"
            )
        }

        // Refer to the diagram in the "Essential Characteristics of I/O Units" section here:
        // https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/AudioUnitHostingGuide_iOS/AudioUnitHostingFundamentals/AudioUnitHostingFundamentals.html
        var hardwareASBD = AudioStreamBasicDescription()
        var size = UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        let _ = AudioUnitGetProperty(audioUnit,
                                          kAudioUnitProperty_StreamFormat,
                                          kAudioUnitScope_Input,
                                          1,
                                          &hardwareASBD,
                                          &size)
        logIf(.debug)?.debug("Hardware mic is natively at \(hardwareASBD.mSampleRate) sample rate")

        // Does not work on macOS. Remove comment in future commit.
        //        var ioFormat = AudioStreamBasicDescription(
        //            mSampleRate: 24000,
        //            mFormatID: kAudioFormatLinearPCM,
        //            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
        //            mBytesPerPacket: 2 /* UInt32(MemoryLayout<Int16>.size) */,
        //            mFramesPerPacket: 1,
        //            mBytesPerFrame: 2 /* UInt32(MemoryLayout<Int16>.size) */,
        //            mChannelsPerFrame: 1,
        //            mBitsPerChannel: 16 /* UInt32(8 * MemoryLayout<Int16>.size) */,
        //            mReserved: 0
        //        )

        // Does not work on macOS. Remove comment in future commit.
        //        var ioFormat = AudioStreamBasicDescription(
        //            mSampleRate: hardwareASBD.mSampleRate,
        //            mFormatID: kAudioFormatLinearPCM,
        //            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
        //            mBytesPerPacket: 2,
        //            mFramesPerPacket: 1,
        //            mBytesPerFrame: 2,
        //            mChannelsPerFrame: 1,
        //            mBitsPerChannel: 16,
        //            mReserved: 0
        //        )

        var ioFormat = AudioStreamBasicDescription(
            mSampleRate: kVoiceProcessingInputSampleRate, // Sample rate (Hz) IMPORTANT, on macOS 44100 is the *only* sample rate that will work with the voice processing AU
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )

        err = AudioUnitSetProperty(audioUnit,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Output,
                                   1,
                                   &ioFormat,
                                   UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        )
        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not set ASBD on the output scope of the mic bus"
            )
        }

        // Suprisingly, we do not need to set the input scope format. Remove in future commit.
        // err = AudioUnitSetProperty(audioUnit,
        //                      kAudioUnitProperty_StreamFormat,
        //                      kAudioUnitScope_Input,
        //                      0,
        //                      &ioFormat,
        //                      UInt32(MemoryLayout<AudioStreamBasicDescription>.size)
        // )
        // guard err == noErr else {
        //     throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
        //         "Could not set ASBD on the input scope of the mic bus"
        //     )
        // }

        #if os(macOS)
        if let deviceID = AIProxyUtils.getDefaultAudioInputDevice() {
            // Try to get 50ms updates.
            // 50ms is half the granularity of our target accumulator (we accumulate into 100ms payloads that we send up to OpenAI)
            var bufferSize: UInt32 = UInt32(kVoiceProcessingInputSampleRate / 20)
            var propertyAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyBufferFrameSize,
                mScope: kAudioDevicePropertyScopeInput,
                mElement: kAudioObjectPropertyElementMain
            )

            let size = UInt32(MemoryLayout.size(ofValue: bufferSize))
            let status = AudioObjectSetPropertyData(
                deviceID,
                &propertyAddress,
                0,
                nil,
                size,
                &bufferSize
            )

            if status != noErr {
                logIf(.debug)?.debug("Could not set desired buffer size")
            }
        }
        #endif

        var inputCallbackStruct = AURenderCallbackStruct(
            inputProc: audioRenderCallback,
            inputProcRefCon: Unmanaged.passUnretained(self).toOpaque()
        )
        err = AudioUnitSetProperty(audioUnit,
                                   kAudioOutputUnitProperty_SetInputCallback /* kAudioUnitProperty_SetRenderCallback */,
                                   kAudioUnitScope_Global /* kAudioUnitScope_Input */,
                                   1,
                                   &inputCallbackStruct,
                                   UInt32(MemoryLayout<AURenderCallbackStruct>.size))

        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not set the render callback on the voice processing audio unit"
            )
        }

        #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
        // Make voice processing explicit so route changes do not accidentally bypass AEC.
        var disableBypass: UInt32 = 0
        err = AudioUnitSetProperty(
            audioUnit,
            kAUVoiceIOProperty_BypassVoiceProcessing,
            kAudioUnitScope_Global,
            0,
            &disableBypass,
            UInt32(MemoryLayout<UInt32>.size)
        )
        if err != noErr {
            logIf(.warning)?.warning("Could not force-enable VPIO voice processing: \(err)")
        }

        // Disable AGC to avoid amplifying far-end leakage into the uplink.
        var disableAGC: UInt32 = 0
        err = AudioUnitSetProperty(
            audioUnit,
            kAUVoiceIOProperty_VoiceProcessingEnableAGC,
            kAudioUnitScope_Global,
            1,
            &disableAGC,
            UInt32(MemoryLayout<UInt32>.size)
        )
        if err != noErr {
            logIf(.warning)?.warning("Could not disable VPIO AGC: \(err)")
        }
        #endif

        // If we have an AVAudioEngine in manual rendering mode, set up the VPIO output bus
        // to pull rendered audio. This gives the VPIO visibility into playback for AEC.
        if shouldEnableSpeakerBusForAEC, audioEngine != nil {
            var outputFormat = AudioStreamBasicDescription(
                mSampleRate: kVoiceProcessingInputSampleRate,  // 44100
                mFormatID: kAudioFormatLinearPCM,
                mFormatFlags: kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked,
                mBytesPerPacket: 4,
                mFramesPerPacket: 1,
                mBytesPerFrame: 4,
                mChannelsPerFrame: 1,
                mBitsPerChannel: 32,
                mReserved: 0
            )
            err = AudioUnitSetProperty(audioUnit,
                                       kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Input,
                                       0,  // Bus 0 (speaker)
                                       &outputFormat,
                                       UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
            guard err == noErr else {
                throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                    "Could not set stream format on the input scope of the speaker bus"
                )
            }

            var outputCallbackStruct = AURenderCallbackStruct(
                inputProc: audioOutputRenderCallback,
                inputProcRefCon: Unmanaged.passUnretained(self).toOpaque()
            )
            err = AudioUnitSetProperty(audioUnit,
                                       kAudioUnitProperty_SetRenderCallback,
                                       kAudioUnitScope_Input,
                                       0,  // Bus 0
                                       &outputCallbackStruct,
                                       UInt32(MemoryLayout<AURenderCallbackStruct>.size))
            guard err == noErr else {
                throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                    "Could not set the output render callback on the voice processing audio unit"
                )
            }
        }

        err = AudioUnitInitialize(audioUnit)
        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not initialize the audio unit"
            )
        }

        err = AudioOutputUnitStart(audioUnit)
        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not start the audio unit"
            )
        }

        return AsyncStream<AVAudioPCMBuffer> { [weak self] continuation in
            self?.continuation = continuation
        }
    }

    public func stop() {
        self.continuation?.finish()
        self.continuation = nil
        if let au = self.audioUnit {
            AudioOutputUnitStop(au)
            AudioUnitUninitialize(au)
            AudioComponentInstanceDispose(au)
            self.audioUnit = nil
        }
        self.microphonePCMSampleVendorCommon.audioConverter = nil
    }

    fileprivate func didReceiveRenderCallback(
        _ ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
        _ inTimeStamp: UnsafePointer<AudioTimeStamp>,
        _ inBusNumber: UInt32,
        _ inNumberFrames: UInt32
    ) {
        // iOS does not respect the buffer size we ask for. macOS is much closer. I'm accumulating them downstream anyway:
        // print("Got \(inNumberFrames) frames - expected \(UInt(kVoiceProcessingInputSampleRate /  20))")
        guard let audioUnit = audioUnit else {
            logIf(.error)?.error("There is no audioUnit attached to the sample vendor. Render callback should not be called")
            return
        }
        var bufferList = AudioBufferList(
            mNumberBuffers: 1,
            mBuffers: AudioBuffer(
                mNumberChannels: 1,
                mDataByteSize: inNumberFrames * 2,
                mData: UnsafeMutableRawPointer.allocate(
                    byteCount: Int(inNumberFrames) * 2,
                    alignment: MemoryLayout<Int16>.alignment
                )
            )
        )

        let status = AudioUnitRender(audioUnit,
                                     ioActionFlags,
                                     inTimeStamp,
                                     inBusNumber,
                                     inNumberFrames,
                                     &bufferList)

        guard status == noErr else {
            logIf(.error)?.error("Could not render voice processed audio data to bufferList")
            return
        }

        #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
        if self.shouldSuppressLikelyEchoInput(bufferList: bufferList, frameCount: inNumberFrames) {
            return
        }
        #endif

        guard let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: kVoiceProcessingInputSampleRate,
            channels: 1,
            interleaved: true
        ) else {
            logIf(.error)?.error("Could not create audio format inside render callback.")
            return
        }

        if let sampleBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, bufferListNoCopy: &bufferList),
           let accumulatedBuffer = self.microphonePCMSampleVendorCommon.resampleAndAccumulate(sampleBuffer) {
            // If the buffer has accumulated to a sufficient level, give it back to the caller
            Task { @AIProxyActor in
                self.continuation?.yield(accumulatedBuffer)
            }
        }
    }

    /// Called from the VPIO output render callback on the real-time audio thread.
    /// Pulls rendered audio from the AVAudioEngine's manual rendering block and writes it
    /// into the VPIO's output buffer so the VPIO can use it as the AEC reference signal.
    fileprivate func didReceiveOutputRenderCallback(
        _ ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
        _ inTimeStamp: UnsafePointer<AudioTimeStamp>,
        _ inBusNumber: UInt32,
        _ inNumberFrames: UInt32,
        _ ioData: UnsafeMutablePointer<AudioBufferList>?
    ) {
        guard let ioData = ioData, let audioEngine = audioEngine else {
            // No engine — render silence
            if let ioData = ioData {
                let buf = UnsafeMutableAudioBufferListPointer(ioData)
                for i in 0..<buf.count {
                    memset(buf[i].mData, 0, Int(buf[i].mDataByteSize))
                }
            }
            return
        }
        var error: OSStatus = noErr
        let status = audioEngine.manualRenderingBlock(inNumberFrames, ioData, &error)
        if status != .success {
            // On error or insufficient data, fill with silence
            let buf = UnsafeMutableAudioBufferListPointer(ioData)
            for i in 0..<buf.count {
                memset(buf[i].mData, 0, Int(buf[i].mDataByteSize))
            }
            #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
            self.noteRenderedOutput(ioData, frameCount: inNumberFrames)
            #endif
            return
        }
        #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
        self.noteRenderedOutput(ioData, frameCount: inNumberFrames)
        #endif
    }

    #if os(iOS) // iOS-first guard: non-iOS behavior has not been validated for this path yet.
    private func noteRenderedOutput(
        _ ioData: UnsafeMutablePointer<AudioBufferList>,
        frameCount: UInt32
    ) {
        let outputRMS = self.rms(ofFloat32BufferList: ioData)
        let now = ProcessInfo.processInfo.systemUptime

        if outputRMS > kEchoGuardOutputRMSFloor {
            let bufferDuration = Double(frameCount) / kVoiceProcessingInputSampleRate
            self.outputLikelyActiveUntilUptime = now + bufferDuration + kEchoGuardOutputTailSeconds
            if self.outputSmoothedRMS == 0 {
                self.outputSmoothedRMS = outputRMS
            } else {
                self.outputSmoothedRMS = (self.outputSmoothedRMS * (1 - kEchoGuardRMSSmoothingFactor))
                                         + (outputRMS * kEchoGuardRMSSmoothingFactor)
            }
            return
        }

        if now > self.outputLikelyActiveUntilUptime {
            self.outputSmoothedRMS = 0
            self.micLoudFrameStreak = 0
        }
    }

    private func shouldSuppressLikelyEchoInput(
        bufferList: AudioBufferList,
        frameCount: UInt32
    ) -> Bool {
        let now = ProcessInfo.processInfo.systemUptime
        if now <= self.bargeInOpenUntilUptime {
            return false
        }

        guard now <= self.outputLikelyActiveUntilUptime else {
            self.micLoudFrameStreak = 0
            return false
        }

        let micRMS = self.rms(ofPCM16BufferList: bufferList, frameCount: frameCount)
        let bargeInThreshold = max(
            kEchoGuardBargeInThresholdFloor,
            self.outputSmoothedRMS * kEchoGuardBargeInRelativeMultiplier
        )

        if micRMS >= bargeInThreshold {
            self.micLoudFrameStreak += 1
            if self.micLoudFrameStreak >= kEchoGuardFramesForBargeIn {
                self.micLoudFrameStreak = 0
                self.bargeInOpenUntilUptime = now + kEchoGuardBargeInHoldSeconds
                return false
            }
        } else {
            self.micLoudFrameStreak = 0
        }

        return true
    }

    private func rms(
        ofPCM16BufferList bufferList: AudioBufferList,
        frameCount: UInt32
    ) -> Float {
        guard frameCount > 0,
              let data = bufferList.mBuffers.mData else {
            return 0
        }

        let sampleCount = Int(frameCount)
        let samples = data.bindMemory(to: Int16.self, capacity: sampleCount)
        let scale = Float(Int16.max)
        var sumSquares: Float = 0
        for i in 0..<sampleCount {
            let normalized = Float(samples[i]) / scale
            sumSquares += normalized * normalized
        }
        return sqrt(sumSquares / Float(sampleCount))
    }

    private func rms(ofFloat32BufferList ioData: UnsafeMutablePointer<AudioBufferList>) -> Float {
        let buffers = UnsafeMutableAudioBufferListPointer(ioData)
        guard !buffers.isEmpty else {
            return 0
        }

        var sampleCount = 0
        var sumSquares: Float = 0
        for buffer in buffers {
            guard let mData = buffer.mData else { continue }
            let count = Int(buffer.mDataByteSize) / MemoryLayout<Float>.size
            if count == 0 { continue }
            let samples = mData.bindMemory(to: Float.self, capacity: count)
            sampleCount += count
            for i in 0..<count {
                let sample = samples[i]
                sumSquares += sample * sample
            }
        }

        guard sampleCount > 0 else {
            return 0
        }
        return sqrt(sumSquares / Float(sampleCount))
    }
    #endif
}

// NOTE:
// This callback is invoked by Core Audio on a real-time I/O thread via C APIs.
// It is not scheduled onto AIProxyActor at runtime, even though the symbol is
// annotated with @AIProxyActor for Swift type-checking ergonomics.
// Do not assume actor isolation/synchronization inside this callback.
@AIProxyActor private let audioOutputRenderCallback: AURenderCallback = {
    inRefCon,
    ioActionFlags,
    inTimeStamp,
    inBusNumber,
    inNumberFrames,
    ioData in
    let vendor = Unmanaged<MicrophonePCMSampleVendorAT>
        .fromOpaque(inRefCon)
        .takeUnretainedValue()
    vendor.didReceiveOutputRenderCallback(
        ioActionFlags,
        inTimeStamp,
        inBusNumber,
        inNumberFrames,
        ioData
    )
    return noErr
}

// NOTE:
// This callback is invoked by Core Audio on a real-time I/O thread via C APIs.
// It is not scheduled onto AIProxyActor at runtime, even though the symbol is
// annotated with @AIProxyActor for Swift type-checking ergonomics.
// Do not assume actor isolation/synchronization inside this callback.
@AIProxyActor private let audioRenderCallback: AURenderCallback = {
    inRefCon,
    ioActionFlags,
    inTimeStamp,
    inBusNumber,
    inNumberFrames,
    ioData in
    let microphonePCMSampleVendor = Unmanaged<MicrophonePCMSampleVendorAT>
        .fromOpaque(inRefCon)
        .takeUnretainedValue()
    microphonePCMSampleVendor.didReceiveRenderCallback(
        ioActionFlags,
        inTimeStamp,
        inBusNumber,
        inNumberFrames
    )
    return noErr
}
#endif
