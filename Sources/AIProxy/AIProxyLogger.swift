import OSLog

public enum AIProxyLogLevel: Int {
    case debug
    case info
    case warning
    case error
    case critical

    func isAtOrAboveThresholdLevel(_ threshold: AIProxyLogLevel) -> Bool {
        return self.rawValue >= threshold.rawValue
    }
}

internal var aiproxyCallerDesiredLogLevel = AIProxyLogLevel.warning
internal let aiproxyLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "UnknownApp",
    category: "AIProxy"
)

// Why not create a wrapper around OSLog instead of forcing log callsites to include an `logIf(<level>)` check?
// Because I like the Xcode log feature that links to the source location of the log.
// If you create a wrapper, even one that is inlined, the Xcode source feature always links to the wrapper location.
//
// H/T Quinn the Eskimo!
// https://developer.apple.com/forums/thread/774931
@inline(__always)
internal func logIf(_ logLevel: AIProxyLogLevel) -> Logger? {
    return logLevel.isAtOrAboveThresholdLevel(aiproxyCallerDesiredLogLevel) ? aiproxyLogger : nil
}
