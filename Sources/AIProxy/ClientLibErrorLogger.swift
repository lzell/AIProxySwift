//
//  DeviceCheckErrorLogger.swift
//  AIProxy
//
//  Created by Lou Zell on 4/1/25.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

private let kLibError = "client-lib-error"
private let kGlobal = "global"

struct ClientLibErrorLogger {
    static func logDeviceCheckNotSupported(clientID: String?) {
        let payload = buildPayload(errorType: "dc-not-supported", errorMessage: nil)
        deliver(payload, clientID: clientID)
    }

    static func logDeviceCheckCouldNotGenerateToken(_ msg: String, clientID: String?) {
        let payload = buildPayload(errorType: "dc-token-gen-failed", errorMessage: msg)
        deliver(payload, clientID: clientID)
    }
}

// Fire and forget delivery
private func deliver(_ payload: Payload, clientID: String?) {
    let session = AIProxy.session()
    if let req = buildRequest(payload, clientID: clientID) {
        Task {
            if let (_, res) = try? await BackgroundNetworker.makeRequestAndWaitForData(session, req) {
                logIf(.debug)?.debug("Fired logging event and received status code \(res.statusCode)")
            }
        }
    }
}

private struct Payload: Encodable {
    let appName: String
    let appVersion: String
    let buildNumber: String
    let deviceModel: String
    let systemName: String
    let osVersion: String
    let errorType: String
    let errorMessage: String?
    let timestamp: Double
}


private func buildPayload(errorType: String, errorMessage: String?) -> Payload {
    let bundle = Bundle.main
    let infoDict = bundle.infoDictionary ?? [:]

    let appName = infoDict["CFBundleName"] as? String ?? "Unknown"
    let appVersion = infoDict["CFBundleShortVersionString"] as? String ?? "Unknown"
    let buildNumber = infoDict["CFBundleVersion"] as? String ?? "Unknown"
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    let osVersionString = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"

    var deviceModel = "Unknown"
    var systemName = "Unknown"

    #if os(iOS) || os(tvOS)
    deviceModel = UIDevice.current.model
    systemName = UIDevice.current.systemName
    #elseif os(watchOS)
    deviceModel = "Apple Watch"
    systemName = "watchOS"
    #elseif os(macOS)
    deviceModel = Host.current().localizedName ?? "Mac"
    systemName = "macOS"
    #endif

    return Payload(
        appName: appName,
        appVersion: appVersion,
        buildNumber: buildNumber,
        deviceModel: deviceModel,
        systemName: systemName,
        osVersion: osVersionString,
        errorType: errorType,
        errorMessage: errorMessage,
        timestamp: Date().timeIntervalSince1970
    )
}

private func buildRequest(_ payload: Payload, clientID: String?) -> URLRequest? {
    guard let body: Data = try? payload.serialize(),
          let libErrorURL = URL(string: ["https://api.aiproxy.pro", kGlobal, kLibError].joined(separator: "/")) else {
          // let libErrorURL = URL(string: ["http://Lous-MacBook-Air-3.local:4000", kGlobal, kLibError].joined(separator: "/")) else {
        return nil
    }

    var request = URLRequest(url: libErrorURL)
    request.httpMethod = "POST"
    request.httpBody = body

    if let clientID = clientID ?? AIProxyIdentifier.getClientID() {
        request.addValue(clientID, forHTTPHeaderField: "aiproxy-client-id")
    }

    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as?  String,
       let bundleID = Bundle.main.bundleIdentifier{
        request.addValue("v2|\(bundleID)|\(appVersion)|\(AIProxy.sdkVersion)", forHTTPHeaderField: "aiproxy-metadata")
    }

    if let resolvedAccount = AnonymousAccountStorage.resolvedAccount {
        request.addValue(resolvedAccount.uuid, forHTTPHeaderField: "aiproxy-anonymous-id")
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
}
