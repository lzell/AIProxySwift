//
//  AIProxyConfiguration.swift
//  AIProxy
//
//  Created by Lou Zell on 7/31/25.
//

internal enum AIProxyConfiguration {

    static var resolveDNSOverTLS: Bool = true
    static var printRequestBodies: Bool = false
    static var printResponseBodies: Bool = false

    static var stableID: String? {
        get {
            ProtectedPropertyQueue.stableID.sync { AIProxyConfiguration._stableID }
        }
        set {
            ProtectedPropertyQueue.stableID.async(flags: .barrier) { AIProxyConfiguration._stableID = newValue }
        }
    }
    static var _stableID: String?

    static var useStableID: Bool {
        get {
            ProtectedPropertyQueue.useStableID.sync { _useStableID }
        }
        set {
            ProtectedPropertyQueue.useStableID.async(flags: .barrier) { _useStableID = newValue }
        }
    }
    private static var _useStableID: Bool = false {
        willSet {
            guard newValue != self._useStableID else {
                return
            }
            if newValue {
                Task.detached {
                    if let stableID = await self._getStableIdentifier() {
                        self.stableID = stableID
                    }
                }
            } else {
                self.stableID = nil
            }
        }
    }

    internal static func _getStableIdentifier() async -> String? {
        #if !DEBUG
        if let appTransactionID = await AIProxyUtils.getAppTransactionID() {
            return appTransactionID
        }
        #endif
        do {
            return try await AnonymousAccountStorage.sync()
        } catch {
            logIf(.error)?.error("AIProxy: Could not configure an anonymous account: \(error.localizedDescription)")
        }
        return nil
    }
}
