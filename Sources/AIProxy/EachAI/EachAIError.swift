//
//  EachAIError.swift
//
//
//  Created by Lou Zell on 12/8/24.
//

import Foundation

enum EachAIError: LocalizedError {
    case reachedRetryLimit

    var errorDescription: String? {
        switch self {
        case .reachedRetryLimit:
            return "Reached EachAI polling retry limit"
        }
    }
}
