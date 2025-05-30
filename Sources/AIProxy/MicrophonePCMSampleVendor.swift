//
//  MicrophonePCMSampleVendor.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

import AVFoundation

@RealtimeActor
protocol MicrophonePCMSampleVendor: AnyObject {
    func start() throws -> AsyncStream<AVAudioPCMBuffer>
    func stop()
}
