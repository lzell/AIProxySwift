//
//  AudioPCMPlayerError.swift
//  AIProxy
//
//  Created by Lou Zell on 2/20/25.
//

import Foundation

public enum AudioPCMPlayerError: LocalizedError {
    case couldNotConfigureAudioEngine(String)

    public var errorDescription: String? {
        switch self {
        case .couldNotConfigureAudioEngine(let message):
            return message
        }
    }
}
