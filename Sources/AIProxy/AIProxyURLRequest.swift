//
//  AIProxyURLRequest.swift
//
//
//  Created by Lou Zell on 8/6/24.
//

import Foundation

enum AIProxyURLRequest {

    /// Creates a URLRequest that is configured for use with an AIProxy URLSession.
    /// Can raise `AIProxyError.deviceCheckIsUnavailable` or `AIProxyError.deviceCheckBypassIsMissing`
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
        request.networkServiceType = .avStreaming
        request.httpMethod = verb.toString(hasBody: body != nil)
        request.httpBody = body
        request.addValue(partialKey, forHTTPHeaderField: "aiproxy-partial-key")
        request.addValue(resolvedClientID, forHTTPHeaderField: "aiproxy-client-id")

        request.addValue(
            AIProxyUtils.metadataHeader(withBodySize: body?.count ?? 0),
            forHTTPHeaderField: "aiproxy-metadata"
        )

        if let resolvedAccount = AnonymousAccountStorage.resolvedAccount {
            request.addValue(resolvedAccount.uuid, forHTTPHeaderField: "aiproxy-anonymous-id")
        }

    #if targetEnvironment(simulator)
        guard let deviceCheckBypass = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"] else {
            throw AIProxyError.deviceCheckBypassIsMissing
        }
        request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
    #else
        guard let deviceCheckToken = await AIProxyDeviceCheck.getToken(forClient: resolvedClientID) else {
            throw AIProxyError.deviceCheckIsUnavailable
        }
        request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
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
        request.networkServiceType = .avStreaming
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
