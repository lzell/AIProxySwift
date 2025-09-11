//
//  FalProxiedService.swift
//
//
//  Created by Lou Zell on 9/13/24.
//

import Foundation

@AIProxyActor final class FalProxiedService: FalService, ProxiedService, Sendable {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.falService` defined in AIProxy.swift
    nonisolated init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Creates an inference on Fal. The returned value contains a URL that you can check for
    /// the status of your inference..
    ///
    /// You may want to start in `FalService+Convenience.swift` to see if there is already a
    /// convenience function for your use case. If there is not, use the method bodies in that file as
    /// inspiration to build your own using this method and the polling methods below.
    public func createInference<T: Encodable>(
        model: String,
        input: T
    ) async throws -> FalQueueResponseBody {
        var model = model
        if !model.starts(with: "/") {
            model = "/" + model
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: model,
            body: input.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }


    /// Gets the response object from a completed inference. The URL to pass is the
    /// `response_url` described here: https://fal.ai/docs/model-endpoints/queue
    ///
    /// You should only call this method once `pollForInferenceComplete` returns.
    /// `pollForInferenceComplete` is defined in the protocol extension in `FalService.swift`
    ///
    /// - Parameter url: The `responseURL` that is returned as part of `FalQueueResponseBody`
    ///
    /// - Returns: A decodable type that you define to match your model's "output schema". To find the
    ///            output schema, navigate to the model on Fal, then tap on "API" and scroll down until
    ///            you find the "Output" section. Here is an example:
    ///            https://fal.ai/models/fal-ai/fast-sdxl/api#schema-output
    public func getResponse<T: Decodable & Sendable>(
        url: URL
    ) async throws -> T {
        guard url.host == "queue.fal.run" else {
            throw AIProxyError.assertion("Fal has changed the image polling domain")
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: url.path,
            body: nil,
            verb: .get,
            secondsToWait: 60
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try T.deserialize(from: data)
    }

    /// Uploads a file to Fal's short term storage for use in a subsequent call. For example,
    /// you can upload an image to short term storage that you then use as input to ControlNet.
    ///
    /// - Parameters:
    ///   - fileData: The binary representation of your file
    ///   - name: name of the file
    ///   - contentType: Content-type, e.g. `image/png` for PNG files or `application/zip` for zip files
    /// - Returns: The URL of the file on Fal's short term storage.
    public func uploadFile(
        fileData: Data,
        name: String,
        contentType: String
    ) async throws -> URL {
        let initiateUpload = FalInitiateUploadRequestBody(contentType: contentType, fileName: name)
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/storage/upload/initiate",
            body: initiateUpload.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )

        let initiateRes: FalInitiateUploadResponseBody = try await self.makeRequestAndDeserializeResponse(request)
        var uploadReq = URLRequest(url: initiateRes.uploadURL)
        uploadReq.httpMethod = "PUT"
        uploadReq.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let (storageResponseData, storageResponse) = try await URLSession.shared.upload(for: uploadReq, from: fileData)

        guard let httpStorageResponse = storageResponse as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if httpStorageResponse.statusCode > 299 {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpStorageResponse.statusCode,
                responseBody: String(data: storageResponseData, encoding: .utf8) ?? ""
            )
        }

        return initiateRes.fileURL
    }
}
