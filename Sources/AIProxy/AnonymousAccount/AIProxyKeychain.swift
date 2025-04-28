//
//  AIProxyKeychain.swift
//  AIProxy
//
//  Created by Lou Zell on 1/30/25.
//

// ----------------------------------------------------------------
// Usage Note:
// Try the helpers in AIProxyStorage.swift before using these directly
// ----------------------------------------------------------------

import Foundation

struct AIProxyKeychain {

    enum Scope {
        case local(keychainAccount: String)
        case remote(keychainAccount: String)

        var keychainAccount: String {
            switch self {
            case .local(let keychainAccount): return keychainAccount
            case .remote(let keychainAccount): return keychainAccount
            }
        }
    }

    let keychainServiceName = (Bundle.main.bundleIdentifier ?? "com.example") + ".aiproxy-keychain"
    let serialQueue = DispatchQueue(label: "aiproxy-keychain")

    let secClass: NSCopying
    let secAttrGeneric: NSCopying
    let secAttrAccount: NSCopying
    let secAttrService: NSCopying
    let secAttrSynchronizable: NSCopying
    let secMatchLimit: NSCopying
    let secReturnData: NSCopying
    let secValueData: NSCopying
    let cfBooleanTrue: CFBoolean

    init?() {
        guard let secClass = kSecClass as? NSCopying,
              let secAttrGeneric = kSecAttrGeneric as? NSCopying,
              let secAttrAccount = kSecAttrAccount as? NSCopying,
              let secAttrService = kSecAttrService as? NSCopying,
              let secAttrSynchronizable = kSecAttrSynchronizable as? NSCopying,
              let secMatchLimit = kSecMatchLimit as? NSCopying,
              let secReturnData = kSecReturnData as? NSCopying,
              let secValueData = kSecValueData as? NSCopying,
              let cfBooleanTrue = kCFBooleanTrue
        else {
            return nil
        }

        self.secClass = secClass
        self.secAttrGeneric = secAttrGeneric
        self.secAttrAccount = secAttrAccount
        self.secAttrService = secAttrService
        self.secAttrSynchronizable = secAttrSynchronizable
        self.secMatchLimit = secMatchLimit
        self.secReturnData = secReturnData
        self.secValueData = secValueData
        self.cfBooleanTrue = cfBooleanTrue
    }

    func retrieve(scope: Scope) async -> Data? {
        return await withCheckedContinuation { continuation in
            self.serialQueue.async {
                let data = self.searchKeychainCopyMatching(scope: scope)
                DispatchQueue.main.async {
                    continuation.resume(returning: data)
                }
            }
        }
    }

    func create(data: Data, scope: Scope) async -> OSStatus {
        return await withCheckedContinuation { continuation in
            self.serialQueue.async {
                let res = self.createKeychainValue(data: data, scope: scope)
                DispatchQueue.main.async {
                    continuation.resume(returning: res)
                }
            }
        }
    }

    func update(data: Data, scope: Scope) async -> OSStatus {
        return await withCheckedContinuation { continuation in
            self.serialQueue.async {
                let res = self.updateKeychainValue(data: data, scope: scope)
                DispatchQueue.main.async {
                    continuation.resume(returning: res)
                }
            }
        }
    }

    func clear(scope: Scope) {
        self.serialQueue.async {
            self.deleteKeychainValue(scope: scope)
        }
    }

    // MARK: - Private
    private func newSearchDictionary(scope: Scope) -> NSMutableDictionary {
        let searchDictionary = NSMutableDictionary()
        searchDictionary.setObject(kSecClassGenericPassword, forKey: self.secClass)
        searchDictionary.setObject(self.keychainServiceName, forKey: self.secAttrService)
        searchDictionary.setObject(scope.keychainAccount, forKey: self.secAttrGeneric)
        searchDictionary.setObject(scope.keychainAccount, forKey: self.secAttrAccount)
        if case .remote = scope {
            searchDictionary.setObject(self.cfBooleanTrue, forKey: self.secAttrSynchronizable)
        }
        return searchDictionary
    }

    private func searchKeychainCopyMatching(scope: Scope) -> Data? {
        let searchDictionary = self.newSearchDictionary(scope: scope)
        searchDictionary.setObject(kSecMatchLimitOne, forKey: self.secMatchLimit)
        searchDictionary.setObject(self.cfBooleanTrue, forKey: self.secReturnData)
        var queryResult: AnyObject?

        var status: OSStatus = noErr
        withUnsafeMutablePointer(to: &queryResult) {
            status = SecItemCopyMatching(searchDictionary, UnsafeMutablePointer($0))
        }
        if status == errSecItemNotFound {
            return nil
        }
        if status == noErr {
            return queryResult as? Data
        }
        logIf(.error)?.error("Unexpected keychain error in searchKeychainCopyMatching: \(status)")
        return nil
    }

    private func createKeychainValue(data: Data, scope: Scope) -> OSStatus {
        let dictionary = self.newSearchDictionary(scope: scope)
        dictionary.setObject(data, forKey:self.secValueData)
        return SecItemAdd(dictionary, nil)
    }

    private func updateKeychainValue(data: Data, scope: Scope) -> OSStatus {
        let searchDictionary = newSearchDictionary(scope: scope)
        let updateDictionary = NSMutableDictionary()
        updateDictionary.setObject(data, forKey: self.secValueData)
        return SecItemUpdate(searchDictionary, updateDictionary)
    }

    private func deleteKeychainValue(scope: Scope) {
      let searchDictionary = newSearchDictionary(scope: scope)
      SecItemDelete(searchDictionary)
    }
}
