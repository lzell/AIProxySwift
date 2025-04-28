//
//  MicrophonePCMSampleVendorError.swift
//  AIProxy
//
//  Created by Lou Zell on 2/20/25.
//

import Foundation

public enum MicrophonePCMSampleVendorError: LocalizedError {
    case couldNotConfigureAudioUnit(String)

    public var errorDescription: String? {
        switch self {
        case .couldNotConfigureAudioUnit(let message):
            return message
        }
    }
}
