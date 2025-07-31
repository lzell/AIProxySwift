//
//  AnonymousAccountStorage.swift
//  AIProxy
//
//  Created by Lou Zell on 2/2/25.
//

import Foundation

/// The purpose of this class is to set `resolvedAccount` to a stable identifier.
///
/// # Usage
///
/// - At app launch, call `Task.defer { AIProxy.configure }`, which internally will call `sync`.
/// - Any requests through AIProxy will automatically include the UUID of `resolvedAccount` in the request headers.
///
final class AnonymousAccountStorage {
    /// A best-effort anonymous ID that is stable across multiple devices of an iCloud account
    static var resolvedAccount: AnonymousAccount? {
        get {
            ProtectedPropertyQueue.resolvedAccount.sync { _resolvedAccount }
        }
        set {
            ProtectedPropertyQueue.resolvedAccount.async(flags: .barrier) { _resolvedAccount = newValue }
        }
    }
    private static var _resolvedAccount: AnonymousAccount?

    /// The account chain that lead to the current resolution.
    private static var localAccountChain: [AnonymousAccount] = []

    /// This is expected to be called as part of the application launch.
    static func sync() async throws -> String {

        #if false
        try await AIProxyStorage.clear()
        #endif

        // The first task is to populate self.localAccountChain.
        // If we already have an account chain in keychain, great.
        // Otherwise, create a new anonymous account and use that as the full chain.
        //
        // It's possible and likely that the local account chain will be updated later in this routine.
        // That's fine, as the purpose of the local account chain is to hold history.
        // That history shows when the stable identifier was able to be sync'd from the other device.
        var _localAccountChain = try await AIProxyStorage.getLocalAccountChainFromKeychain()
        if _localAccountChain == nil {
            _localAccountChain = try await AIProxyStorage.writeNewLocalAccountChain()
        }
        guard let _localAccountChain = _localAccountChain,
              var localAccount = _localAccountChain.last else {
            throw AIProxyError.assertion("Broken invariant. localAccount must be populated with at least one element.")
        }
        self.localAccountChain = _localAccountChain


        // Next we try to get any anonymous account that is already stored in NSUbiquitousKeyValueStore.
        // We do not store a full chain there, it's intended to be used for the 'best account' of the chain,
        // meaning the one that was created earliest. The design of this class is to eventually resolve out
        // to the earliest account across multiple devices.
        if !AIProxyStorage.ukvsSync() {
            logIf(.error)?.error("AIProxy: Could not synchronize NSUbiquitousKeyValueStore. Please ensure you enabled the key/value store in Target > Signing & Capabilities > iCloud > Key-Value storage")
        }
        if let ukvsAccountData = AIProxyStorage.ukvsAccountData() {
            let ukvsAccount = try AnonymousAccount.deserialize(from: ukvsAccountData)
            if ukvsAccount != localAccount {
                // The account in UKVS is different from the local account.
                // If the UKVS account was created earlier, update the local account.
                // If the UKVS account was create dlater, update the UKVS account.
                if ukvsAccount.timestamp <= localAccount.timestamp {
                    localAccount = ukvsAccount
                    self.localAccountChain.append(ukvsAccount)
                    if try await AIProxyStorage.updateLocalAccountChainInKeychain(self.localAccountChain) != noErr {
                        logIf(.warning)?.warning("Could not update the local account chain")
                    }
                } else {
                    try AIProxyStorage.updateUKVS(localAccount)
                }
            }
        } else {
            // There is no account in UKVS, so write one now
            try AIProxyStorage.updateUKVS(localAccount)
        }


        // Next we try to get any anonymous account that is already stored in the iCloud-backed keychain.
        // We do not store a full chain there, it's intended to be used for the 'best account' of the chain,
        // meaning the one that was created earliest. The design of this class is to eventually resolve out
        // to the earliest account across multiple devices.
        //
        // It's worth noting that the identifiers we use for the local keychain and iCloud-backed keychain
        // are different. The local keychain does *not* try to sync to iCloud. We use that store as purely
        // on-device authority.
        if try await AIProxyStorage.writeAccountToRemoteKeychain(localAccount) == errSecDuplicateItem {
            if let remoteAccount = try await AIProxyStorage.getRemoteAccountFromKeychain() {
                if remoteAccount != localAccount {
                    // The account in remote keychain is different from the local account.
                    // If the remote keychain account was created earlier, update the local account *and* the UKVS account.
                    // If the remote keychain account was created later, update the remote keychain account.
                    if remoteAccount.timestamp <= localAccount.timestamp {
                        localAccount = remoteAccount
                        self.localAccountChain.append(remoteAccount)
                        if try await AIProxyStorage.updateLocalAccountChainInKeychain(self.localAccountChain) != noErr {
                            logIf(.warning)?.warning("Could not update the local account chain")
                        }
                        try AIProxyStorage.updateUKVS(localAccount)
                    } else {
                        if try await AIProxyStorage.updateRemoteAccountInKeychain(localAccount) != noErr {
                            logIf(.warning)?.warning("Could not update the remote account")
                        }
                    }
                }
            } else {
                logIf(.warning)?.warning("Keychain cloud sync claims that there is a duplicate item, but we can't fetch it.")
            }
        }

        // We are done resolving accounts at launch. Set the current resolved account, and listen for changes on NSUbiquitousKeyValueStore
        self.resolvedAccount = localAccount
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeDidChange),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)

        logIf(.debug)?.debug("Local account chain is \(localAccountChain)")
        logIf(.debug)?.debug("Anonymous account identifier is \(self.resolvedAccount?.uuid ?? "unknown")")

        return localAccount.uuid
    }

    /// Called when NSUbiquitousKeyValueStore was remotely updated.
    /// See https://developer.apple.com/library/archive/documentation/General/Conceptual/iCloudDesignGuide/Chapters/DesigningForKey-ValueDataIniCloud.html#//apple_ref/doc/uid/TP40012094-CH7-SW6
    //  See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/StoringPreferenceDatainiCloud/StoringPreferenceDatainiCloud.html
    @objc
    private static func storeDidChange(_ notification: Notification) {
        guard let changedKeys = notification.userInfo?["NSUbiquitousKeyValueStoreChangedKeysKey"] as? [String],
              changedKeys.contains(kAIProxyUKVSAccount) else {
            return
        }

        guard let resolvedAccount = self.resolvedAccount else {
            return
        }

        guard let changeReason = notification.userInfo?["NSUbiquitousKeyValueStoreChangeReasonKey"] as? NSNumber else {
            return
        }

        switch changeReason.intValue {
        case NSUbiquitousKeyValueStoreServerChange: logIf(.info)?.info("AIProxy account changed due to remote server change")
        case NSUbiquitousKeyValueStoreInitialSyncChange: logIf(.info)?.info("AIProxy account changed due to initial sync change")
        case NSUbiquitousKeyValueStoreQuotaViolationChange: logIf(.info)?.info("AIProxy account changed due to quota violation")
        case NSUbiquitousKeyValueStoreAccountChange: logIf(.info)?.info("AIProxy account changed due to icloud account change")
        default:
            return
        }

        guard AIProxyStorage.ukvsSync() else {
            return
        }

        guard let ukvsAccountData = AIProxyStorage.ukvsAccountData(),
              let ukvsAccount = try? AnonymousAccount.deserialize(from: ukvsAccountData) else {
            return
        }

        guard ukvsAccount != resolvedAccount else {
            logIf(.info)?.info("UKVS remote sync is already up to date")
            return
        }

        if ukvsAccount.timestamp <= resolvedAccount.timestamp {
            logIf(.info)?.info("UKVS account is older than our existing resolved account. Switching to the older account.")
            self.resolvedAccount = ukvsAccount
            self.localAccountChain.append(ukvsAccount)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .aiproxyResolvedAccountDidChange, object: nil, userInfo: [:])
            }

            Task.detached {
                let updateLocal = try? await AIProxyStorage.updateLocalAccountChainInKeychain(self.localAccountChain)
                if updateLocal == nil || updateLocal! != noErr {
                    logIf(.warning)?.warning("Could not update the local account chain")
                }

                let updateRemote = try? await AIProxyStorage.updateRemoteAccountInKeychain(ukvsAccount)
                if updateRemote == nil || updateRemote! != noErr {
                    logIf(.warning)?.warning("Could not update the remote account")
                }
            }
        } else {
            logIf(.info)?.info("UKVS account is newer than our existing resolved account. Updating UKVS to use the older account.")
            try? AIProxyStorage.updateUKVS(resolvedAccount)
        }
    }
}
