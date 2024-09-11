import Foundation

enum ReplicateError: LocalizedError {
    case predictionCanceled
    case predictionDidNotIncludeOutput
    case predictionDidNotIncludeURL
    case predictionFailed
    case missingModelURL
    case reachedRetryLimit

    var errorDescription: String? {
        switch self {
        case .predictionCanceled:
            return "The prediction was canceled"
        case .predictionDidNotIncludeOutput:
            return "A prediction was successful, but replicate did not include the output schema"
        case .predictionDidNotIncludeURL:
            return "A prediction was created, but replicate did not respond with a URL to poll"
        case .predictionFailed:
            return "The prediction failed. If this is a NSFW prediction, please ensure disableSafetyChecker is set to true."
        case .missingModelURL:
            return "The replicate model does not contain a URL"
        case .reachedRetryLimit:
            return "Reached replicate polling retry limit"
        }
    }
}
