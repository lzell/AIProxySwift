import Foundation

enum ReplicateError: LocalizedError {
    case reachedRetryLimit
    case predictionDidNotIncludeURL
    case predictionDidNotIncludeOutput

    var errorDescription: String? {
        switch self {
        case .reachedRetryLimit:
            return "Reached replicate polling retry limit"
        case .predictionDidNotIncludeURL:
            return "A prediction was created, but replicate did not respond with a URL to poll"
        case .predictionDidNotIncludeOutput:
            return "A prediction was successful, but replicate did not include the output schema"
        }
    }
}
