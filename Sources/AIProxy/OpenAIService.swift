//  AIProxy.swift
//  Created by Lou Zell on 6/12/24.

import Foundation
import DeviceCheck
#if canImport(UIKit)
    import UIKit
#endif
#if canImport(IOKit)
    import IOKit
#endif

private let aiproxyURL = "https://api.aiproxy.pro"
private let aiproxyChatPath = "/v1/chat/completions"
private let challengeDelegate = ChallengeDelegate()


public enum AIProxyError: Error {
    /// Raised when AIProxy can't possibly continue.
    /// If you ever see these in the wild, it's a programmer error by Lou.
    /// Please submit a repro, if possible!
    case programmerError

    /// Raised when the status code of the network response is outside of the [200, 299] range.
    /// The associated Int contains the status code of the failed request.
    /// The associated String contains the response body of the failed request.
    ///
    /// A status code that you may experience in normal operation of your app is a 429, which
    /// means that your request was rate limited. A simple way to test this during development is
    /// to place a really low rate limit in the AIProxy dashboard, and then fire a couple requests
    /// from the simulator to reach the rate limit. You wouldn't want to do this once your app is in
    /// production, because the rate limits that you apply will rate limit live users!
    case unsuccessfulRequest(statusCode: Int, responseBody: String?)
}


public struct OpenAIService {
    private let partialKey: String
    private let deviceCheckBypass: String? = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"]

    /// Please use `AIProxy.openAIService`
    internal init(partialKey: String) {
        self.partialKey = partialKey
    }

    /// Initiates an async/await-based, non-streaming chat completion request to /v1/chat/completions.
    /// See the usage instructions at the top of this file.
    ///
    /// - Parameters:
    ///   - chatRequestBody: The request body to send to aiproxy and openai. See this reference:
    ///                      https://platform.openai.com/docs/api-reference/chat/create
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> OpenAIChatCompletionResponseBody {
        let session = URLSession(configuration: .default, delegate: challengeDelegate, delegateQueue: nil)
        session.sessionDescription = "AIProxy Buffered" // See "Analyze HTTP traffic in Instruments" wwdc session
        let request = try await buildAIProxyRequest(
            partialKey: self.partialKey,
            deviceCheckBypass: self.deviceCheckBypass,
            requestBody: body,
            path: "/v1/chat/completions"
        )
        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.programmerError
        }

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(statusCode: httpResponse.statusCode,
                                                   responseBody: String(data: data, encoding: .utf8))
        }

        return try JSONDecoder().decode(OpenAIChatCompletionResponseBody.self, from: data)
    }
}



// MARK: - Private Helpers

/// Gets a device check token for use in your calls to aiproxy.
/// The device token may be nil when targeting the iOS simulator.
/// See the usage instructions at the top of this file, and ensure that you are conditionally compiling the `deviceCheckBypass` token for iOS simulation only.
/// Do not let the `deviceCheckBypass` token slip into your production codebase, or an attacker can easily use it themselves.
private func getDeviceCheckToken() async -> String? {
    guard DCDevice.current.isSupported else {
        aiproxyLogger.error("DeviceCheck is not available on this device. Are you on the simulator?")
        return nil
    }

    do {
        let data = try await DCDevice.current.generateToken()
        return data.base64EncodedString()
    } catch {
        aiproxyLogger.error("Could not create DeviceCheck token. Are you using an explicit bundle identifier?")
        return nil
    }
}

/// Get a unique ID for this client
private func getClientID() -> String? {
#if canImport(UIKit)
    return UIDevice.current.identifierForVendor?.uuidString
#elseif canImport(IOKit)
    return getIdentifierFromIOKit()
#else
    return nil
#endif
}


/// Builds and AI Proxy request.
/// Used for both streaming and non-streaming chat.
private func buildAIProxyRequest(
    partialKey: String,
    deviceCheckBypass: String?,
    requestBody: Encodable,
    path: String
) async throws -> URLRequest {

    let postBody = try JSONEncoder().encode(requestBody)
    let deviceCheckToken = await getDeviceCheckToken()
    let clientID = getClientID()

    guard var urlComponents = URLComponents(string: aiproxyURL) else {
        aiproxyLogger.error("Could not create urlComponents, please check the aiproxyEndpoint constant")
        throw AIProxyError.programmerError
    }

    urlComponents.path = path
    guard let url = urlComponents.url else {
        aiproxyLogger.error("Could not create a request URL")
        throw AIProxyError.programmerError
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = postBody
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(partialKey, forHTTPHeaderField: "aiproxy-partial-key")

    if let clientID = clientID {
        request.addValue(clientID, forHTTPHeaderField: "aiproxy-client-id")
    }

    if let deviceCheckToken = deviceCheckToken {
        request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
    }

    if let deviceCheckBypass = deviceCheckBypass {
        request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
    }

    return request
}


// MARK: - IOKit conditional dependency
#if canImport(IOKit)
private func getIdentifierFromIOKit() -> String? {
    guard let macBytes = copy_mac_address() as? Data else {
        return nil
    }
    let macHex = macBytes.map { String(format: "%02X", $0) }
    return macHex.joined(separator: ":")
}

// This function is taken from the Apple sample code at:
// https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#3744656
private func io_service(named name: String, wantBuiltIn: Bool) -> io_service_t? {
    let default_port = kIOMainPortDefault
    var iterator = io_iterator_t()
    defer {
        if iterator != IO_OBJECT_NULL {
            IOObjectRelease(iterator)
        }
    }

    guard let matchingDict = IOBSDNameMatching(default_port, 0, name),
        IOServiceGetMatchingServices(default_port,
                                     matchingDict as CFDictionary,
                                     &iterator) == KERN_SUCCESS,
        iterator != IO_OBJECT_NULL
    else {
        return nil
    }

    var candidate = IOIteratorNext(iterator)
    while candidate != IO_OBJECT_NULL {
        if let cftype = IORegistryEntryCreateCFProperty(candidate,
                                                        "IOBuiltin" as CFString,
                                                        kCFAllocatorDefault,
                                                        0) {
            let isBuiltIn = cftype.takeRetainedValue() as! CFBoolean
            if wantBuiltIn == CFBooleanGetValue(isBuiltIn) {
                return candidate
            }
        }

        IOObjectRelease(candidate)
        candidate = IOIteratorNext(iterator)
    }

    return nil
}

// This function is taken from the Apple sample code at:
// https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#3744656
private func copy_mac_address() -> CFData? {
    // Prefer built-in network interfaces.
    // For example, an external Ethernet adaptor can displace
    // the built-in Wi-Fi as en0.
    guard let service = io_service(named: "en0", wantBuiltIn: true)
            ?? io_service(named: "en1", wantBuiltIn: true)
            ?? io_service(named: "en0", wantBuiltIn: false)
        else { return nil }
    defer { IOObjectRelease(service) }

    if let cftype = IORegistryEntrySearchCFProperty(
        service,
        kIOServicePlane,
        "IOMACAddress" as CFString,
        kCFAllocatorDefault,
        IOOptionBits(kIORegistryIterateRecursively | kIORegistryIterateParents)) {
            return (cftype as! CFData)
    }

    return nil
}
#endif
