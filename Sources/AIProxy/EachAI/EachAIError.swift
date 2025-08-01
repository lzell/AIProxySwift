//
//  EachAIError.swift
//
//
//  Created by Lou Zell on 12/8/24.
//

import Foundation

enum EachAIError: LocalizedError {
    case reachedRetryLimit
    case predictionDidNotIncludeOutput

    var errorDescription: String? {
        switch self {
        case .reachedRetryLimit:
            return "Reached EachAI polling retry limit"
        case .predictionDidNotIncludeOutput:
            return "A prediction was successful, but EachAI did not include the output"
        }
    }
}
