//
//  WaveSpeedError.swift
//  AIProxy
//
//  Created by Lou Zell on 10/31/25.
//

import Foundation

nonisolated public enum WaveSpeedAIError: LocalizedError, Sendable {
//    case predictionCanceled
//    case predictionDidNotIncludeOutput
    case predictionDidNotIncludeURL
//    case predictionFailed(String?)
//    case missingModelURL
    case reachedRetryLimit

    public var errorDescription: String? {
        switch self {
//        case .predictionCanceled:
//            return "The prediction was canceled"
//        case .predictionDidNotIncludeOutput:
//            return "A prediction was successful, but replicate did not include the output schema"
        case .predictionDidNotIncludeURL:
            return "A prediction was created, but WaveSpeedAI did not respond with a URL to poll"
//        case .predictionFailed(let message):
//            return message ?? "The prediction failed with an unspecificed error from replicate."
//        case .missingModelURL:
//            return "The replicate model does not contain a URL"
        case .reachedRetryLimit:
            return "Reached WaveSpeedAI polling limit without prediction completing"
        }
    }
}
