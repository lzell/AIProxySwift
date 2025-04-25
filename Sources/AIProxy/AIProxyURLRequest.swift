//
//  AIProxyURLRequest.swift
//
//
//  Created by Lou Zell on 8/6/24.
//

import Foundation

enum AIProxyURLRequest {

    /// Creates a URLRequest that is configured for use with an AIProxy URLSession.
    static func create(
        partialKey: String,
        serviceURL: String,
        clientID: String?,
        proxyPath: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        secondsToWait: UInt,
        contentType: String? = nil,
        additionalHeaders: [String: String] = [:]
    ) async throws -> URLRequest {
        let resolvedClientID = clientID ?? AIProxyIdentifier.getClientID()
        let deviceCheckToken = await AIProxyDeviceCheck.getToken(forClient: resolvedClientID)

        var proxyPath = proxyPath
        if !proxyPath.starts(with: "/") {
            proxyPath = "/\(proxyPath)"
        }

        guard var urlComponents = URLComponents(string: serviceURL),
              let proxyPathComponents = URLComponents(string: proxyPath) else {
            throw AIProxyError.assertion(
                "Could not create urlComponents, please check the aiproxyEndpoint constant"
            )
        }

        urlComponents.path += proxyPathComponents.path
        urlComponents.queryItems = proxyPathComponents.queryItems

        guard let url = urlComponents.url else {
            throw AIProxyError.assertion("Could not create a request URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = verb.toString(hasBody: body != nil)
        request.httpBody = body
        request.addValue(partialKey, forHTTPHeaderField: "aiproxy-partial-key")

        if let resolvedClientID = resolvedClientID {
            request.addValue(resolvedClientID, forHTTPHeaderField: "aiproxy-client-id")
        }

        if let deviceCheckToken = deviceCheckToken {
            request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
        }

        let bundleID = Bundle.main.bundleIdentifier ?? "unknown"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        request.addValue("v3|\(bundleID)|\(appVersion)|\(AIProxy.sdkVersion)|\(Date().timeIntervalSince1970)", forHTTPHeaderField: "aiproxy-metadata")

        if let resolvedAccount = AnonymousAccountStorage.resolvedAccount {
            request.addValue(resolvedAccount.uuid, forHTTPHeaderField: "aiproxy-anonymous-id")
        }

    #if targetEnvironment(simulator)
        if let deviceCheckBypass = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"] {
            request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
        }
    #endif

        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        for (headerField, value) in additionalHeaders {
            request.addValue(value, forHTTPHeaderField: headerField)
        }

        request.timeoutInterval = TimeInterval(secondsToWait)
        return request
    }

    /// Creates a URLRequest that is intended for direct use with the service provider.
    /// WARNING: These requests are not protected by AIProxy's pk pinning, split key encryption, DeviceCheck, or rate limiting.
    static func createDirect(
        baseURL: String,
        path: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        secondsToWait: UInt,
        contentType: String? = nil,
        additionalHeaders: [String: String] = [:]
    ) throws -> URLRequest {
        var path = path
        if !path.starts(with: "/") {
            path = "/\(path)"
        }

        guard var urlComponents = URLComponents(string: baseURL),
              let pathComponents = URLComponents(string: path) else {
            throw AIProxyError.assertion(
                "Could not create urlComponents for the direct-to-provider use case"
            )
        }

        urlComponents.path += pathComponents.path
        urlComponents.queryItems = pathComponents.queryItems

        guard let url = urlComponents.url else {
            throw AIProxyError.assertion("Could not create a request URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = verb.toString(hasBody: body != nil)
        request.httpBody = body

        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        for (headerField, value) in additionalHeaders {
            request.addValue(value, forHTTPHeaderField: headerField)
        }

        request.timeoutInterval = TimeInterval(secondsToWait)
        return request
    }

}
