//
//  AudioUtils.swift
//
//
//  Created by Lou Zell on 11/28/24.
//

import Foundation
import AVFoundation

struct AudioUtils {
    static func base64EncodedPCMData(from sampleBuffer: CMSampleBuffer) -> String? {
        let bytesPerSample = sampleBuffer.sampleSize(at: 0)
        guard bytesPerSample == 2 else {
            aiproxyLogger.warning("Sample buffer does not contain PCM16 data")
            return nil
        }

        let byteCount = sampleBuffer.numSamples * bytesPerSample
        guard byteCount > 0 else {
            return nil
        }

        guard let blockBuffer: CMBlockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
            aiproxyLogger.warning("Could not get CMSampleBuffer data")
            return nil
        }

        if !blockBuffer.isContiguous {
            aiproxyLogger.error("There is a bug here. The audio data is not contiguous and I'm treating it like it is")
            // Alternative approach I haven't tried:
            // https://myswift.tips/2021/09/04/converting-an-audio-(pcm)-cmsamplebuffer-to-a-data-instance.html
        }

        do {
            return try blockBuffer.dataBytes().base64EncodedString()
        } catch {
            aiproxyLogger.warning("Could not get audio data")
            return nil
        }
    }

    init() {
        fatalError("This is a namespace.")
    }
}
