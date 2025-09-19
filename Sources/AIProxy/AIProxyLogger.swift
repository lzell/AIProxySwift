import OSLog

nonisolated public enum AIProxyLogLevel: Int, Sendable {
    case debug
    case info
    case warning
    case error
    case critical

    func isAtOrAboveThresholdLevel(_ threshold: AIProxyLogLevel) -> Bool {
        return self.rawValue >= threshold.rawValue
    }

    /// This must only be accessed through `ProtectedPropertyQueue.callerDesiredLogLevel`.
    nonisolated(unsafe) static var _callerDesiredLogLevel = AIProxyLogLevel.warning
    nonisolated static var callerDesiredLogLevel: AIProxyLogLevel {
        get {
            ProtectedPropertyQueue.callerDesiredLogLevel.sync { self._callerDesiredLogLevel }
        }
        set {
            ProtectedPropertyQueue.callerDesiredLogLevel.async(flags: .barrier) { self._callerDesiredLogLevel = newValue }
        }
    }
}

nonisolated internal let aiproxyLogger = Logger(
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
nonisolated internal func logIf(_ logLevel: AIProxyLogLevel) -> Logger? {
    return logLevel.isAtOrAboveThresholdLevel(AIProxyLogLevel.callerDesiredLogLevel) ? aiproxyLogger : nil
}
