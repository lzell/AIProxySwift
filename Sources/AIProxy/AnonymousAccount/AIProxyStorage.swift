//
//  Storage.swift
//  AIProxy
//
//  Created by Lou Zell on 1/30/25.
//

import Foundation

nonisolated private let kAIProxyLocalAccount = "aiproxy-local"
nonisolated private let kAIProxyRemoteAccount = "aiproxy-remote"
nonisolated internal let kAIProxyUKVSAccount = "aiproxy-ukvs"

@AIProxyActor final class AIProxyStorage: Sendable {

    static private let keychain = AIProxyKeychain()
    static private let ukvs = NSUbiquitousKeyValueStore.default

    static func getLocalAccountChainFromKeychain() async throws -> [AnonymousAccount]? {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        async let retrieve = keychain.retrieve(scope: .local(keychainAccount: kAIProxyLocalAccount))
        if let data = await retrieve {
            return try [AnonymousAccount].deserialize(from: data)
        }
        return nil
    }

    static func updateLocalAccountChainInKeychain(_ localAccountChain: [AnonymousAccount]) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        guard let serializedLocalChain: Data = try? localAccountChain.serialize() else {
            throw AIProxyError.assertion("Could not serialize the local account chain")
        }
        async let update = keychain.update(
            data: serializedLocalChain,
            scope: .local(keychainAccount: kAIProxyLocalAccount)
        )
        return await update
    }

    static func updateRemoteAccountInKeychain(_ newAccount: AnonymousAccount) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        guard let serializedNewAccount: Data = try? newAccount.serialize() else {
            throw AIProxyError.assertion("Could not serialize the new account")
        }
        async let update = keychain.update(
            data: serializedNewAccount,
            scope: .remote(keychainAccount: kAIProxyRemoteAccount)
        )
        return await update
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
        async let create = keychain.create(data: data, scope: .local(keychainAccount: kAIProxyLocalAccount))
        let createStatus = await create
        if createStatus != noErr {
            throw AIProxyError.assertion("Could not write a local account to keychain")
        }
        return accountChain
    }

    static func getRemoteAccountFromKeychain() async throws -> AnonymousAccount? {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        async let retrieve = keychain.retrieve(scope: .remote(keychainAccount: kAIProxyRemoteAccount))
        if let data = await retrieve {
            return try AnonymousAccount.deserialize(from: data)
        }
        return nil
    }


    static func writeAccountToRemoteKeychain(_ account: AnonymousAccount) async throws -> OSStatus {
        guard let keychain = self.keychain else {
            throw AIProxyError.assertion("Keychain is not available")
        }
        let data: Data = try account.serialize()
        async let create = keychain.create(data: data, scope: .remote(keychainAccount: kAIProxyRemoteAccount))
        return await create
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
