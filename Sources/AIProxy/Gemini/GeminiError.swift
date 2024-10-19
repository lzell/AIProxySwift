//
//  GeminiError.swift
//
//
//  Created by Lou Zell on 10/24/24.
//

import Foundation

enum GeminiError: LocalizedError {
    case reachedRetryLimit

    var errorDescription: String? {
        switch self {
        case .reachedRetryLimit:
            return "Reached Gemini polling retry limit"
        }
    }
}
