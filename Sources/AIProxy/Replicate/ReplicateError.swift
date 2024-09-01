import Foundation

enum ReplicateError: LocalizedError {
    case reachedRetryLimit
    case predictionCanceled
    case predictionFailed
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
        case .predictionFailed:
            return "The prediction failed. If this is a NSFW prediction, please ensure disableSafetyChecker is set to true."
        case .predictionCanceled:
            return "The prediction was canceled"
        }
    }
}
