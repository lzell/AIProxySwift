//
//  AIProxyURLRequest.swift
//
//
//  Created by Lou Zell on 8/6/24.
//

import Foundation

// Move this
struct OpenAIWSError: Decodable {
    internal init(type: String, error: [String : Any]) {
        self.type = type
        self.error = error
    }
    
    let type: String
    let error: [String: Any]

    private enum CodingKeys: CodingKey {
        case type
        case error
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        if (type != "error") {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: [CodingKeys.type], debugDescription: "Type should be equal to 'error'"))
        }
        self.type = type
        self.error = try container.decode([String: AIProxyJSONValue].self, forKey: .error).untypedDictionary
    }
}

struct AIProxyURLRequest {

    static func createWS(
        partialKey: String,
        serviceURL: String,
        proxyPath: String,
        clientID: String?
    ) async throws -> URLRequest {
        let deviceCheckToken = await AIProxyDeviceCheck.getToken()

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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("realtime=v1", forHTTPHeaderField: "openai-beta")
        return request

//        // Keep the playground running to receive the message
//        RunLoop.main.run()

//        let deviceCheckToken = await AIProxyDeviceCheck.getToken()
//        guard var urlComponents = URLComponents(string: serviceURL),
//              let proxyPathComponents = URLComponents(string: proxyPath) else {
//            throw AIProxyError.assertion(
//                "Could not create urlComponents, please check the aiproxyEndpoint constant"
//            )
//        }
//
//        urlComponents.path += proxyPathComponents.path
//
    }

    /// Creates an HTTP URLRequest that is configured for use with an AIProxy URLSession.
    static func createHTTP(
        partialKey: String,
        serviceURL: String,
        clientID: String?,
        proxyPath: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        contentType: String? = nil
    ) async throws -> URLRequest {
        let deviceCheckToken = await AIProxyDeviceCheck.getToken()

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

        if let clientID = (clientID ?? AIProxyIdentifier.getClientID()) {
            request.addValue(clientID, forHTTPHeaderField: "aiproxy-client-id")
        }

        if let deviceCheckToken = deviceCheckToken {
            request.addValue(deviceCheckToken, forHTTPHeaderField: "aiproxy-devicecheck")
        }

        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            request.addValue("v1|\(appVersion)", forHTTPHeaderField: "aiproxy-metadata")
        }

    #if DEBUG && targetEnvironment(simulator)
        if let deviceCheckBypass = ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"] {
            request.addValue(deviceCheckBypass, forHTTPHeaderField: "aiproxy-devicecheck-bypass")
        }
    #endif

        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    init() {
        fatalError("This is a namespace. Please use the factory method AIProxyURLRequest.create()")
    }
}
