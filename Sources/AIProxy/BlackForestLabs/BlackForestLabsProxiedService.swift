//
//  BlackForestLabsProxiedService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/8/25.
//

import Foundation

open class BlackForestLabsProxiedService: BlackForestLabsService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.blackForestLabsService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Generates a Flux Pro 1.1 image by making a request to `/v1/flux-pro-1.1`
    ///
    /// - Parameters:
    ///   - body: The request body to send to BFL, protected by AIProxy. See this reference:
    ///   https://api.bfl.ml/scalar#tag/tasks/POST/v1/flux-pro-1.1
    ///
    /// - Returns: The generated image.
    public func fluxProRequest_v1_1(
        body: BlackForestLabsFluxProRequestBody_v1_1
    ) async throws -> Void {

        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://delivery-eu1.bfl.ai",
            path: "/results/bd16c3be7bb446f5aa8b008faf10e0d8/sample.jpeg?se=2025-01-09T05%3A04%3A04Z&sp=r&sv=2024-11-04&sr=b&rsct=image/jpeg&sig=hAiu66Cdzf8MSujO6%2BQgcA2s3Ki9/%2BpIp/BsQ/oyGTw%3D",
            body:  nil,
            verb: .get,
            contentType: "application/json",
            additionalHeaders: [
                "X-Key": "1de12326-93f2-41b6-a01e-295808c006ff"
            ]
        )

        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            AIProxyUtils.directURLSession(),
            request
        )

//        self.makeRequestAndDeserializeResponse(<#T##URLRequest#>)


//        try await self.getResponse(id: "cc06c929-49e6-4571-9efc-50955141e287")

//        let request = try await AIProxyURLRequest.create(
//            partialKey: self.partialKey,
//            serviceURL: self.serviceURL,
//            clientID: self.clientID,
//            proxyPath: "/v1/flux-pro-1.1",
//            body: body.serialize(),
//            verb: .post,
//            contentType: "application/json"
//        )
//        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
//            self.urlSession,
//            request
//        )
//
//        guard let jsonWithID = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//           let id = jsonWithID["id"] as? String else {
//            print("Throwing an error!")
//            return
//        }
//        print("Polling for id \(id)")
    }

    public func getResponse(
        id: String
    ) async throws -> Void {
//        guard url.host == "queue.fal.run" else {
//            throw AIProxyError.assertion("Fal has changed the image polling domain")
//        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/get_result?id=\(id)",
            body: nil,
            verb: .get
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
    }

}

