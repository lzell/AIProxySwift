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

// Why not create a wrapper around OSLog instead of forcing log callsites to include an `if ll(<level>)` check?
// Because I like the Xcode log feature that links to the source location of the log.
// If you create a wrapper, even one that is inlined, the Xcode source feature always links to the wrapper location.
@inline(__always)
internal func ll(_ logLevel: AIProxyLogLevel) -> Bool {
    return logLevel.isAtOrAboveThresholdLevel(aiproxyCallerDesiredLogLevel)
}
