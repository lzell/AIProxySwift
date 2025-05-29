//
//  RealtimeAudioManager.swift
//  AIProxy
//
//  Created by Lou Zell on 5/29/25.
//

@RealtimeActor
final class RealtimeAudioManager {
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private let useAudioToolbox: Bool

    init() {
        #if os(macOS)
        useAudioToolbox = !AIProxyUtils.headphonesConnected
        #else
        useAudioToolbox = false
        #endif

        if !useAudioToolbox {
            self.inputNode = self.audioEngine.inputNode
        }
    }

    func start() throws {
        self.audioEngine.prepare()
        try self.audioEngine.start()
    }

    

}
