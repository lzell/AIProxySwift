//
//  Storage.swift
//  AIProxy
//
//  Created by Lou Zell on 1/30/25.
//

import Foundation

private let kAIProxyLocalAccount = "aiproxy-local"
private let kAIProxyRemoteAccount = "aiproxy-remote"
internal let kAIProxyUKVSAccount = "aiproxy-ukvs"


final class AIProxyStorage {

    static private let keychain = AIProxyKeychain()
    static private let ukvs = NSUbiquitousKeyValueStore.default

    static func getLocalAccountChainFromKeychain() async throws -> [AnonymousAccount]? {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        if let data = await keychain.retrieve(scope: .local(keychainAccount: kAIProxyLocalAccount)) {
            return try [AnonymousAccount].deserialize(from: data)
        }
        return nil
    }

    static func updateLocalAccountChainInKeychain(_ localAccountChain: [AnonymousAccount]) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        return await keychain.update(
            data: try localAccountChain.serialize(),
            scope: .local(keychainAccount: kAIProxyLocalAccount)
        )
    }

    static func updateRemoteAccountInKeychain(_ newAccount: AnonymousAccount) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        return await keychain.update(
            data: try newAccount.serialize(),
            scope: .remote(keychainAccount: kAIProxyRemoteAccount)
        )
    }


    static func writeNewLocalAccountChain() async throws -> [AnonymousAccount] {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        let accountChain = [AnonymousAccount(
            uuid: UUID().uuidString,
            timestamp: Date().timeIntervalSince1970
        )]
        let data: Data = try accountChain.serialize()
        let createStatus = await keychain.create(data: data, scope: .local(keychainAccount: kAIProxyLocalAccount))
        if createStatus != noErr {
            throw AIProxyError.assertion("Could not write a local account to keychain")
        }
        return accountChain
    }

    static func getRemoteAccountFromKeychain() async throws -> AnonymousAccount? {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        if let data = await keychain.retrieve(scope: .remote(keychainAccount: kAIProxyRemoteAccount)) {
            return try AnonymousAccount.deserialize(from: data)
        }
        return nil
    }


    static func writeAccountToRemoteKeychain(_ account: AnonymousAccount) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        let data: Data = try account.serialize()
        return await keychain.create(data: data, scope: .remote(keychainAccount: kAIProxyRemoteAccount))
    }

    static func clear() async throws {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        keychain.clear(scope: .local(keychainAccount: kAIProxyLocalAccount))
        keychain.clear(scope: .remote(keychainAccount: kAIProxyRemoteAccount))
        self.ukvs.removeObject(forKey: kAIProxyUKVSAccount)
    }

    static func ukvsAccountData() -> Data? {
        return self.ukvs.data(forKey: kAIProxyUKVSAccount)
    }

    static func ukvsSync() -> Bool {
        return self.ukvs.synchronize()
    }

    static func updateUKVS(_ account: AnonymousAccount) throws {
        let accountData: Data = try account.serialize()
        self.ukvs.set(accountData, forKey: kAIProxyUKVSAccount)
    }
}

extension Notification.Name {
    static let aiproxyResolvedAccountDidChange = Notification.Name("aiproxyResolvedAccountDidChange")
}
