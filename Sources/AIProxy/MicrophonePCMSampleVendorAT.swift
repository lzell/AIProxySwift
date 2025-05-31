//
//  MicrophonePCMSampleVendorAT.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

#if os(macOS) || os(iOS)

import AVFoundation
import AudioToolbox
import Foundation

private let kVoiceProcessingInputSampleRate: Double = 44100

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
@RealtimeActor
internal class MicrophonePCMSampleVendorAT: MicrophonePCMSampleVendor {

    private var audioUnit: AudioUnit?
    private let microphonePCMSampleVendorCommon = MicrophonePCMSampleVendorCommon()
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?

    public init() {}

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

        var zero: UInt32 = 0
        err = AudioUnitSetProperty(audioUnit,
                                   kAudioOutputUnitProperty_EnableIO,
                                   kAudioUnitScope_Output,
                                   0,
                                   &zero, // <-- This is not a mistake! If you leave this on, iOS spams the logs with: "from AU (address): auou/vpio/appl, render err: -1"
                                   UInt32(MemoryLayout.size(ofValue: one)))

        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not disable the output scope of the speaker bus"
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

        // Do not use auto gain control. Remove in a future commit.
        // var enable: UInt32 = 1
        // err = AudioUnitSetProperty(audioUnit,
        //                      kAUVoiceIOProperty_VoiceProcessingEnableAGC,
        //                      kAudioUnitScope_Output,
        //                      1,
        //                      &enable,
        //                      UInt32(MemoryLayout.size(ofValue: enable)))
        //
        guard err == noErr else {
            throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                "Could not configure auto gain control"
            )
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
            self.continuation?.yield(accumulatedBuffer)
        }
    }
}

@RealtimeActor
private let audioRenderCallback: AURenderCallback = {
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
