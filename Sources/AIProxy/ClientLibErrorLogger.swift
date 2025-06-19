//
//  DeviceCheckErrorLogger.swift
//  AIProxy
//
//  Created by Lou Zell on 4/1/25.
//

import Foundation

private let kLibError = "client-lib-error"
private let kGlobal = "global"

struct ClientLibErrorLogger {
    static func logClientIdentifierIsNil() {
        let payload = buildPayload(errorType: "error-client-id-nil", errorMessage: nil)
        deliver(payload, clientID: nil)
    }

    static func logDeviceCheckSingletonIsNil(clientID: String?) {
        let payload = buildPayload(errorType: "error-dc-singleton-nil", errorMessage: nil)
        deliver(payload, clientID: clientID)
    }

    static func logDeviceCheckNotSupported(clientID: String?) {
        let payload = buildPayload(errorType: "error-dc-not-supported", errorMessage: nil)
        deliver(payload, clientID: clientID)
    }

    static func logDeviceCheckCouldNotGenerateToken(_ msg: String, clientID: String?) {
        let payload = buildPayload(errorType: "error-dc-token-gen-failed", errorMessage: msg)
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
    let runtimeInfo = RuntimeInfo.current

    return Payload(
        appName: runtimeInfo.appName,
        appVersion: runtimeInfo.appVersion,
        buildNumber: runtimeInfo.buildNumber,
        deviceModel: runtimeInfo.deviceModel,
        systemName: runtimeInfo.systemName,
        osVersion: runtimeInfo.osVersion,
        errorType: errorType,
        errorMessage: errorMessage,
        timestamp: Date().timeIntervalSince1970
    )
}

private func buildRequest(_ payload: Payload, clientID: String?) -> URLRequest? {
    guard let body: Data = try? payload.serialize(),
          let libErrorURL = URL(string: ["https://api.aiproxy.com", kGlobal, kLibError].joined(separator: "/")) else {
          // let libErrorURL = URL(string: ["http://Lous-MacBook-Air-3.local:4000", kGlobal, kLibError].joined(separator: "/")) else {
        return nil
    }

    var request = URLRequest(url: libErrorURL)
    request.httpMethod = "POST"
    request.httpBody = body
    request.addValue(clientID ?? AIProxyIdentifier.getClientID(), forHTTPHeaderField: "aiproxy-client-id")

    request.addValue(
        AIProxyUtils.metadataHeader(withBodySize: body.count),
        forHTTPHeaderField: "aiproxy-metadata"
    )

    if let resolvedAccount = AnonymousAccountStorage.resolvedAccount {
        request.addValue(resolvedAccount.uuid, forHTTPHeaderField: "aiproxy-anonymous-id")
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
}
