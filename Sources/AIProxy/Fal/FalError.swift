//
//  FalError.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

enum FalError: LocalizedError {
    case missingResultURL
    case missingStatusURL
    case reachedRetryLimit

    var errorDescription: String? {
        switch self {
        case .missingResultURL:
            return "Fal finished inference, but did not contain a URL for us to fetch the result with"
        case .missingStatusURL:
            return "Fal request was queued, but the response did not contain a status URL"
        case .reachedRetryLimit:
            return "Reached Fal polling retry limit"
        }
    }
}
