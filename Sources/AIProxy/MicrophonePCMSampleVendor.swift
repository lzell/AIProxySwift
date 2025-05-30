//
//  MicrophonePCMSampleVendor.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

import AVFoundation

internal protocol MicrophonePCMSampleVendor {
    var audioConverter: AVAudioConverter? { get }
    func setAudioConverter(_ audioConverter: AVAudioConverter?)

    func start() throws -> AsyncStream<AVAudioPCMBuffer>
    func stop()
}

extension MicrophonePCMSampleVendor {
    func convertPCM16BufferToExpectedSampleRate(_ pcm16Buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        // if ll(.debug) { aiproxyLogger.debug("Captured \(pcm16Buffer.frameLength) pcm16 samples from the mic") }
        guard let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatInt16,
            sampleRate: 24000.0,
            channels: 1,
            interleaved: false
        ) else {
            logIf(.error)?.error("Could not create target audio format")
            return nil
        }

        if self.audioConverter == nil {
            self.setAudioConverter(AVAudioConverter(from: pcm16Buffer.format, to: audioFormat))
        }

        guard let converter = self.audioConverter else {
            logIf(.error)?.error("There is no audio converter to use for PCM16 resampling")
            return nil
        }

        guard let outputBuffer = AVAudioPCMBuffer(
            pcmFormat: audioFormat,
            frameCapacity: AVAudioFrameCount(audioFormat.sampleRate * 2.0)
        ) else {
            logIf(.error)?.error("Could not create output buffer for PCM16 resampling")
            return nil
        }

#if false
        writePCM16IntValuesToFile(from: pcm16Buffer, location: "output1.txt")
#endif

        // See the docstring on AVAudioConverterInputBlock in AVAudioConverter.h
        //
        // The block will keep getting invoked until either the frame capacity is
        // reached or outStatus.pointee is set to `.noDataNow` or `.endStream`.
        var error: NSError?
        var ptr: UInt32 = 0
        let targetFrameLength = pcm16Buffer.frameLength
        let _ = converter.convert(to: outputBuffer, error: &error) { numberOfFrames, outStatus in
            guard ptr < targetFrameLength,
                  let workingCopy = advancedPCMBuffer_noCopy(pcm16Buffer, offset: ptr)
            else {
                outStatus.pointee = .noDataNow
                return nil
            }
            let amountToFill = min(numberOfFrames, targetFrameLength - ptr)
            outStatus.pointee = .haveData
            ptr += amountToFill
            workingCopy.frameLength = amountToFill
            return workingCopy
        }

        if let error = error {
            logIf(.error)?.error("Error converting to expected sample rate: \(error.localizedDescription)")
            return nil
        }

#if false
        writePCM16IntValuesToFile(from: outputBuffer, location: "output2.txt")
#endif

        return outputBuffer
    }
}


private func advancedPCMBuffer_noCopy(_ originalBuffer: AVAudioPCMBuffer, offset: UInt32) -> AVAudioPCMBuffer? {
    let audioBufferList = originalBuffer.mutableAudioBufferList
    guard audioBufferList.pointee.mNumberBuffers == 1,
          audioBufferList.pointee.mBuffers.mNumberChannels == 1
    else {
        logIf(.error)?.error("Broken programmer assumption. Audio conversion depends on single channel PCM16 as input")
        return nil
    }
    guard let audioBufferData = audioBufferList.pointee.mBuffers.mData else {
        logIf(.error)?.error("Could not get audio buffer data from the original PCM16 buffer")
        return nil
    }
    // advanced(by:) is O(1)
    audioBufferList.pointee.mBuffers.mData = audioBufferData.advanced(
        by: Int(offset) * MemoryLayout<UInt16>.size  // <-- Can I use something smarter here than hardcoding the UInt16 in?
    )
    return AVAudioPCMBuffer(
        pcmFormat: originalBuffer.format,
        bufferListNoCopy: audioBufferList
    )
}

// For debugging purposes only.
private func writePCM16IntValuesToFile(from buffer: AVAudioPCMBuffer, location: String) {
    guard let audioBufferList = buffer.audioBufferList.pointee.mBuffers.mData else {
        print("No audio data available to write to disk")
        return
    }

    // Get the samples
    let c = Int(buffer.frameLength)
    let pointer = audioBufferList.bindMemory(to: Int16.self, capacity: c)
    let samples = UnsafeBufferPointer(start: pointer, count: c)

    // Append them to a file for debugging
    let fileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads/\(location)")
    let content = samples.map { String($0) }.joined(separator: "\n") + "\n"
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
    } else {
        let fileHandle = try! FileHandle(forWritingTo: fileURL)
        defer { fileHandle.closeFile() }
        fileHandle.seekToEndOfFile()
        if let data = content.data(using: .utf8) {
            fileHandle.write(data)
        }
    }
}
