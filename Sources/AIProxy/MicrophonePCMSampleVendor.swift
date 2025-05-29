//
//  MicrophonePCMSampleVendor.swift
//  AIProxy
//
//  Created by Lou Zell
//

// This file is not compatible with watchOS
#if os(watchOS) || os(macOS)
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The class for handling AVAudioEngine.
*/

import AVFoundation
import Foundation
import CoreAudio

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
private class MicrophonePCMSampleVendor {
    private let avAudioEngine: AVAudioEngine
    private let inputNode: AVAudioInputNode
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?
    private var audioConverter: AVAudioConverter?


    init(avAudioEngine: AVAudioEngine, inputNode: AVAudioInputNode) {
        self.avAudioEngine = avAudioEngine
        self.inputNode = inputNode

//        self.inputNode = avAudioEngine.inputNode
        print("lzell \(inputNode.inputFormat(forBus: 0))")
        // Only conditionally enable this if my headphones are not applied. Bizarrely, this causes the mic on my headphones to not work at all.
        // Wait am I sure I want this at all? This really dips the output volume, which I need if the AI is talking
        //
        // It's also possible that just by using audio engine our problems will be solved.
        // Important! Do not try to use inputNode.inputFormat(forBus: 0) after enabling setVoiceProcessingEnabled.
        // Turning on voice processing changes the mic input format from a single channel to five channels, and
        // those five channels do not play nicely with AVAudioConverter.
        // Instead, specify a desired format on the input tap and let AudioEngine deal with the conversion itself.

        // And do I want this?
        // self.inputNode!.isVoiceProcessingBypassed = false

    }
    deinit {
        logIf(.debug)?.debug("MicrophonePCMSampleVendor is being freed")
    }


    public func start() throws -> AsyncStream<AVAudioPCMBuffer> {
        print("Input node sample rate is at: \(self.inputNode.inputFormat(forBus: 0).sampleRate)")
        print("Output node sample rate is at: \(self.inputNode.outputFormat(forBus: 0).sampleRate)")
        guard let desiredTapFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: inputNode.outputFormat(forBus: 0).sampleRate, // 44100 /* self.inputNode.inputFormat(forBus: 0).sampleRate */,
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
        // var firstSampleThrownOut = false
        print("Target buffer size is \(targetBufferSize)")

        //let avAudioEngine = AVAudioEngine()
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
//        avAudioEngine.stop()
//        avAudioEngine = nil
        audioConverter = nil
    }
}


#endif

#if !os(watchOS) && !os(macOS)
import AVFoundation
import AudioToolbox
import Foundation

let kVoiceProcessingInputSampleRate: Double = 44100

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
/// ```
///     let microphoneVendor = MicrophonePCMSampleVendor()
///     try microphoneVendor.start { sample in
///        // Do something with `sample`
///
///     }
///     // some time later...
///     microphoneVendor.stop()
/// ```
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
open class MicrophonePCMSampleVendor {

    private var audioUnit: AudioUnit?
    private var audioConverter: AVAudioConverter?
    private var continuation: AsyncStream<AVAudioPCMBuffer>.Continuation?
    private var inputAudioSampleRate: Double = 0

    public init() {}

    deinit {
        logIf(.debug)?.debug("MicrophonePCMSampleVendor is being freed")
    }

    public func start() throws -> AsyncStream<AVAudioPCMBuffer> {
        #if os(macOS)
        let subType = AIProxyUtils.headphonesConnected ? kAudioUnitSubType_HALOutput : kAudioUnitSubType_VoiceProcessingIO
        #else
        let subType = AIProxyUtils.headphonesConnected ? kAudioUnitSubType_RemoteIO : kAudioUnitSubType_VoiceProcessingIO
        #endif

        var desc = AudioComponentDescription(
            componentType: kAudioUnitType_Output,
            componentSubType: subType,
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

        // CRITICAL: Set the current device for input
            // Without this, the audio unit won't know which device to use
            var deviceID = AudioDeviceID()
            var size1 = UInt32(MemoryLayout<AudioDeviceID>.size)
            var address = AudioObjectPropertyAddress(
                mSelector: kAudioHardwarePropertyDefaultInputDevice,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )

            err = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                             &address,
                                             0,
                                             nil,
                                             &size1,
                                             &deviceID)

            guard err == noErr else {
                throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                    "Could not get default input device. Error: \(err)"
                )
            }

            // Set the device on the audio unit
            err = AudioUnitSetProperty(audioUnit,
                                       kAudioOutputUnitProperty_CurrentDevice,
                                       kAudioUnitScope_Global,
                                       1, // Input element
                                       &deviceID,
                                       UInt32(MemoryLayout<AudioDeviceID>.size))

            guard err == noErr else {
                throw MicrophonePCMSampleVendorError.couldNotConfigureAudioUnit(
                    "Could not set current device on audio unit. Error: \(err)"
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
        self.inputAudioSampleRate = hardwareASBD.mSampleRate
        #if os(macOS)
        if subType == kAudioUnitSubType_VoiceProcessingIO {
            // Sample rate (Hz) IMPORTANT, on macOS 44100 is the *only* sample rate that will work with the voice processing AU
            self.inputAudioSampleRate = kVoiceProcessingInputSampleRate
        }
        #endif

        var ioFormat = AudioStreamBasicDescription(
            mSampleRate: self.inputAudioSampleRate,
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
        self.audioConverter = nil
    }

    fileprivate func didReceiveRenderCallback(
        _ ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
        _ inTimeStamp: UnsafePointer<AudioTimeStamp>,
        _ inBusNumber: UInt32,
        _ inNumberFrames: UInt32
    ) {
        //print("IN RENDER CALLBACK")
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
            sampleRate: self.inputAudioSampleRate,
            channels: 1,
            interleaved: true
        ) else {
            logIf(.error)?.error("Could not create audio format inside render callback.")
            return
        }

        if let inPCMBuf = AVAudioPCMBuffer(pcmFormat: audioFormat, bufferListNoCopy: &bufferList),
           let outPCMBuf = self.convertPCM16BufferToExpectedSampleRate(inPCMBuf)  {
            self.continuation?.yield(outPCMBuf)
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
    let microphonePCMSampleVendor = Unmanaged<MicrophonePCMSampleVendor>
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
