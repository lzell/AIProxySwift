//
//  MicrophoneSampleVendor.swift
//
//  Created by Lou Zell
//

/// Removed in favor of MicrophonePCMSampleVendor. Remove in a future commit.
#if false

import Foundation
import CoreMedia
import AVFoundation

private let kAudioSampleQueue = DispatchQueue(label: "com.AIProxy.audioSampleQueue")

/// One of the following errors will be thrown at initialization if the microphone vendor can't vend samples.
enum MicrophoneSampleVendorError: Error {
    case micNotFound
    case micNotUsableAsCaptureDevice
    case captureSessionRejectedMic
    case captureSessionRejectedOutput
}

/// Vends samples of the microphone audio
///
/// ## Requirements
///
/// - Assumes an `NSMicrophoneUsageDescription` description has been added to Target > Info
/// - Assumes that microphone permissions have already been granted
///
/// ## Usage
///
/// ```
///     self.microphoneVendor = try MicrophoneSampleVendor()
///     self.microphoneVendor.start { sample in
///        // Do something with `sample`
///        // Note: this callback is invoked on a background thread
///     }
/// ```
///
@RealtimeActor
final class MicrophoneSampleVendor {

    private let captureSession = AVCaptureSession()
    private let audioOutput = AVCaptureAudioDataOutput()
    private let sampleBufferDelegate = SampleBufferDelegate()

    init(microphone: AVCaptureDevice? = nil) throws {
        let mic: AVCaptureDevice
        if let microphone = microphone {
            mic = microphone
        } else {
            mic = try findMic()
        }
        let micInput = try mic.asInput()
        try self.captureSession.addMicInput(micInput)
#if os(macOS)
        // TODO: Figure out when this API was introduced on macOS and fix the version here:
        if #available(macOS 12.0, *) {
            self.audioOutput.audioSettings = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVLinearPCMBitDepthKey: 16,
                AVSampleRateKey: 24000.0,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsNonInterleaved: false,
                AVNumberOfChannelsKey: 1
            ]
        }
#endif
        try self.captureSession.addAudioOutput(self.audioOutput)
        self.audioOutput.setSampleBufferDelegate(self.sampleBufferDelegate,
                                                 queue: kAudioSampleQueue)
    }

    func start(onSample: @escaping (CMSampleBuffer) async -> Void) {
        self.sampleBufferDelegate.sampleCallback = onSample
        self.captureSession.startRunning()
    }

    func stop() {
        self.captureSession.stopRunning()
    }
}

private class SampleBufferDelegate: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    var sampleCallback: ((CMSampleBuffer) async -> Void)?

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        dispatchPrecondition(condition: .onQueue(kAudioSampleQueue))
        Task { @RealtimeActor [weak self] in
            guard let self = self else {
                return
            }
            await self.sampleCallback?(sampleBuffer)
        }
    }
}

// TODO: Do I need to support targets below macOS 14.0 and iOS 17.0?
private func findMic() throws -> AVCaptureDevice {
    if #available(macOS 14.0, iOS 17.0, *) {
        let microphones = AVCaptureDevice.DiscoverySession(deviceTypes: [.microphone], mediaType: .audio, position: .front).devices
        if let mic = microphones.first {
            return mic
        }
    }
    throw MicrophoneSampleVendorError.micNotFound
}

private extension AVCaptureDevice {
    func asInput() throws -> AVCaptureDeviceInput {
        do {
            return try AVCaptureDeviceInput(device: self)
        } catch {
            throw MicrophoneSampleVendorError.micNotUsableAsCaptureDevice
        }
    }
}

private extension AVCaptureSession {
    func addMicInput(_ micInput: AVCaptureDeviceInput) throws {
        if self.canAddInput(micInput) {
            self.addInput(micInput)
        } else {
            throw MicrophoneSampleVendorError.captureSessionRejectedMic
        }
    }

    func addAudioOutput(_ audioOutput: AVCaptureAudioDataOutput) throws {
        if self.canAddOutput(audioOutput) {
            self.addOutput(audioOutput)
        } else {
            throw MicrophoneSampleVendorError.captureSessionRejectedMic
        }
    }
}

#endif
