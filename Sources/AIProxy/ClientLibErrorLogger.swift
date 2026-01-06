//
//  DeviceCheckErrorLogger.swift
//  AIProxy
//
//  Created by Lou Zell on 4/1/25.
//
import Foundation

nonisolated private let kLibError = "client-lib-error"
nonisolated private let kGlobal = "global"

@AIProxyActor struct ClientLibErrorLogger {
    static func logClientIdentifierIsNil() async {
        let payload = await buildPayload(errorType: "error-client-id-nil", errorMessage: nil)
        deliver(payload, clientID: nil)
    }

    static func logDeviceCheckSingletonIsNil(clientID: String?) async {
        let payload = await buildPayload(errorType: "error-dc-singleton-nil", errorMessage: nil)
        deliver(payload, clientID: clientID)
    }

    static func logDeviceCheckNotSupported(clientID: String?) async {
        let payload = await buildPayload(errorType: "error-dc-not-supported", errorMessage: nil)
        deliver(payload, clientID: clientID)
    }

    static func logDeviceCheckCouldNotGenerateToken(_ msg: String, clientID: String?) async {
        let payload = await buildPayload(errorType: "error-dc-token-gen-failed", errorMessage: msg)
        deliver(payload, clientID: clientID)
    }
}

// Fire and forget delivery
@AIProxyActor private func deliver(_ payload: Payload, clientID: String?) {
    Task {
        let session = AIProxy.session()
        do {
            let req = try await buildRequest(payload, clientID: clientID)
            if let (_, res) = try? await BackgroundNetworker.makeRequestAndWaitForData(session, req) {
                logIf(.debug)?.debug("Fired logging event and received status code \(res.statusCode)")
            }
        } catch {
            logIf(.error)?.error("Could not build lib error: \(error)")
        }
    }
}

@AIProxyActor private struct Payload: Encodable {
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

@AIProxyActor private func buildPayload(errorType: String, errorMessage: String?) async -> Payload {
    let runtimeInfo = await RuntimeInfo.getCurrent()

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

@AIProxyActor private func buildRequest(_ payload: Payload, clientID: String?) async throws -> URLRequest {
    let body: Data = try payload.serialize()
    guard let libErrorURL = URL(string: ["https://api.aiproxy.com", kGlobal, kLibError].joined(separator: "/")) else {
         // let libErrorURL = URL(string: ["http://Lous-MacBook-Air-3.local:4000", kGlobal, kLibError].joined(separator: "/")) else {
        throw AIProxyError.assertion("Could not build request in ClientLibErrorLogger")
    }

    let resolvedClientID = await getResolvedClientID(clientID)
    var request = URLRequest(url: libErrorURL)
    request.httpMethod = "POST"
    request.httpBody = body
    request.addValue(resolvedClientID, forHTTPHeaderField: "aiproxy-client-id")

    request.addValue(
        await AIProxyUtils.metadataHeader(withBodySize: body.count),
        forHTTPHeaderField: "aiproxy-metadata"
    )

    if let resolvedAccount = AnonymousAccountStorage.resolvedAccount {
        request.addValue(resolvedAccount.uuid, forHTTPHeaderField: "aiproxy-anonymous-id")
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
}

nonisolated private func getResolvedClientID(_ clientID: String?) async -> String {
    if let clientID {
        return clientID
    }
    return await AIProxyIdentifier.getClientID()
}
