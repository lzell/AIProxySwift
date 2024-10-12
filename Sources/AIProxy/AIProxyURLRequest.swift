//
//  AIProxyURLRequest.swift
//
//
//  Created by Lou Zell on 8/6/24.
//

import Foundation

struct AIProxyURLRequest {

    static func createWS(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) async throws /* -> URLRequest */ {
        guard let urlComponents = URLComponents(string: serviceURL) else {
            throw AIProxyError.assertion(
                "Could not create urlComponents, please check the aiproxyEndpoint constant"
            )
        }
        let url = urlComponents.url!
        // Snip out the https as of the schema.
        let session = AIProxyURLSession.create()

        let webSocketTask = session.webSocketTask(with: url)

        // Function to receive messages
        func receiveMessage() {
            webSocketTask.receive { result in
                switch result {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                    case .string(let text):
                        print("Received string: \(text)")
                    case .data(let data):
                        print("Received data: \(data)")
                    @unknown default:
                        print("Received an unknown message")
                    }
                }
            }
        }

        // Start the WebSocket connection
        webSocketTask.resume()

        // Call the receive function
        receiveMessage()

        // Keep the playground running to receive the message
        RunLoop.main.run()

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
