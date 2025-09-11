//
//  ReplicateProxiedService.swift
//
//  Created by Lou Zell on 8/23/24.
//

import Foundation

private let kTimeoutBufferForSyncAPIInSeconds: UInt = 5

@AIProxyActor final class ReplicateProxiedService: ReplicateService, ProxiedService, Sendable {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.replicateService` defined in AIProxy.swift
    nonisolated init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// You likely do not want to start with this method unless you have specific reasons for doing so.
    /// Please see `runOfficialModel`, which automatically handles waiting for the prediction to complete.
    ///
    /// This method will only succeed if the prediction completes within 60 seconds. By contrast, `runOfficialModel`
    /// can wait longer, automatically switching from the sync API to the polling API if necessary.
    ///
    /// # Usage
    ///
    /// This is the general purpose method for running official replicate models.
    /// It is generic in the input and output, so it's up to you to pass the appropriate types.
    ///
    /// To craft the appropriate types, look at the model's schema on replicate.
    /// You can find the schema by browsing to the model and tapping on `API` in the top nav and then `Schema` in the side nav.
    /// If the output schema is a `URL`, for example, you can call this with (note the specialization of `<URL>` in the type annotation):
    ///
    ///     let predictionResponseBody: ReplicatePrediction<URL> = replicateService.createSynchronousPredictionUsingOfficialModel(...)
    ///
    /// # References:
    ///   - https://replicate.com/docs/reference/http#models.predictions.create
    ///
    /// - Parameters:
    ///
    ///   - modelOwner: The model owner. This is not your account name.
    ///               The owner is displayed in the URL of the model you are trying to call
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The prediction response body
    public func createSynchronousPredictionUsingOfficialModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: Input,
        secondsToWait: UInt
    )  async throws -> ReplicatePrediction<Output> {
        let secondsToWait = self.safeSecondsToWait(secondsToWait, warn: true)
        let requestBody = ReplicatePredictionRequestBody(input: input)
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: requestBody.serialize(),
            verb: .post,
            secondsToWait: secondsToWait + kTimeoutBufferForSyncAPIInSeconds,
            contentType: "application/json",
            additionalHeaders: ["Prefer": "wait=\(min(secondsToWait, 60))"]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// You likely do not want to start with this method unless you have specific reasons for doing so.
    /// Please see `runCommunityModel`, which automatically handles waiting for the prediction to complete.
    ///
    /// This method will only succeed if the prediction completes within 60 seconds. By contrast, `runCommunityModel`
    /// can wait longer, automatically switching from the sync API to the polling API if necessary.
    ///
    /// # Usage
    /// This is the general purpose method for running official replicate models.
    /// It is generic in the input and output, so it's up to you to pass the appropriate types.
    ///
    /// To craft the appropriate types, look at the model's schema on replicate.
    /// You can find the schema by browsing to the model and tapping on `API` in the top nav and then `Schema` in the side nav.
    /// If the output schema is a `URL`, for example, you can call this with (note the specialization of `<URL>` in the type annotation):
    ///
    ///     let predictionResponseBody: ReplicatePrediction<URL> = replicateService.createSynchronousPredictionUsingVersion(...)
    ///
    /// # References:
    ///   - https://replicate.com/docs/reference/http#predictions.create
    ///
    /// - Parameters:
    ///
    ///   - modelVersion: The version of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The prediction response body
    public func createSynchronousPredictionUsingCommunityModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelVersion: String,
        input: Input,
        secondsToWait: UInt
    ) async throws -> ReplicatePrediction<Output> {
        let secondsToWait = self.safeSecondsToWait(secondsToWait, warn: true)
        let requestBody = ReplicatePredictionRequestBody(
            input: input,
            version: modelVersion
        )
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: requestBody.serialize(),
            verb: .post,
            secondsToWait: secondsToWait + kTimeoutBufferForSyncAPIInSeconds,
            contentType: "application/json",
            additionalHeaders: ["Prefer": "wait=\(secondsToWait)"]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// You likely do not want to start with this method unless you have specific reasons for doing so.
    /// Please see `runOfficialModel`, which automatically handles waiting for the prediction result.
    ///
    /// This method kicks off the prediction, but does not wait for completion. It is intended to be used in
    /// combination with `pollForPredictionCompletion`
    ///
    /// By contrast, `runOfficialModel` will use the sync API to wait for the prediction result, automatically
    /// switching from the sync API to the polling API if necessary.
    ///
    /// # References:
    ///   - https://replicate.com/docs/reference/http#models.predictions.create
    ///
    /// - Parameters:
    ///
    ///   - modelOwner: The owner of the model
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: A prediction object specialized by the `Output`, e.g. `ReplicateFluxSchnellOutputSchema`.
    ///            The prediction object contains a `url` that can be queried using `getPrediction` or `pollForPredictionCompletion`.
    public func createPredictionUsingOfficialModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: Input
    ) async throws -> ReplicatePrediction<Output> {
        let requestBody = ReplicatePredictionRequestBody(input: input)
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: requestBody.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// You likely do not want to start with this method unless you have specific reasons for doing so.
    /// Please see `runCommunityModel`, which automatically handles waiting for the prediction result.
    ///
    /// This method kicks off the prediction, but does not wait for completion. It is intended to be used in
    /// combination with `pollForPredictionCompletion`
    ///
    /// By contrast, `runCommunityModel` will use the sync API to wait for the prediction result, automatically
    /// switching from the sync API to the polling API if necessary.
    ///
    /// # References:
    ///   - https://replicate.com/docs/reference/http#predictions.create
    ///
    /// - Parameters:
    ///
    ///   - version: The version of the community model that you would like to create a prediction
    ///
    ///   - input: The input schema, for example `ReplicateSDXLInputSchema`
    ///
    /// - Returns: A prediction object specialized by the `Output`, e.g. `ReplicateSDXLOutputSchema`.
    ///            The prediction object contains a `url` that can be queried using `getPrediction` or `pollForPredictionCompletion`.
    public func createPredictionUsingCommunityModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        version: String,
        input: Input
    ) async throws -> ReplicatePrediction<Output> {
        let requestBody = ReplicatePredictionRequestBody(
            input: input,
            version: version
        )
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: requestBody.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Get the current state of a prediction.
    ///
    /// If you need to poll for the prediction to complete, see `pollForPredictionCompletion` defined below.
    ///
    /// # References
    /// - https://replicate.com/docs/reference/http#predictions.get
    ///
    /// - Parameters:
    ///   - url: The prediction URL returned as part of a `createPrediction` request
    ///
    /// - Returns: The prediction response body specialized by `Output`, which must be a decodable that matches the output schema of this model
    public func getPrediction<Output: Decodable & Sendable>(
        url: URL
    ) async throws -> ReplicatePrediction<Output> {
        guard url.host == "api.replicate.com" else {
            throw AIProxyError.assertion("Replicate has changed the poll domain")
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
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Adds a new public or private model to your replicate account.
    /// You can use this as a starting point to fine-tune Flux.
    ///
    /// - Parameters:
    ///
    ///   - owner: Your replicate account
    ///
    ///   - name: The name of the model
    ///
    ///   - description: A description of your model
    ///
    ///   - hardware: From replicate's docs:
    ///               Choose the type of hardware you want your model to run on. This will affect how the
    ///               model performs and how much it costs to run. The billing docs show the specifications
    ///               of the different hardware available and how much each costs: https://replicate.com/docs/billing
    ///
    ///               If your model requires a GPU to run, choose a lower-price GPU model to start, like the
    ///               Nvidia T4 GPU. Later in this guide, you'll learn how to use deployments so you can
    ///               customize the hardware on the fly.
    ///
    ///   - visibility:  From replicate's docs:
    ///                  Visibility: Public models can be discovered and used by anyone. Private models can only be seen
    ///                  by the user or organization that owns them.
    ///
    ///                  Cost: When running public models, you only pay for the time it takes to process your request.
    ///                  When running private models, you also pay for setup and idle time. Take a look at how billing
    ///                  works on Replicate for a full explanation.: https://replicate.com/docs/billing
    ///
    /// - Returns: URL of the model
    public func createModel(
        owner: String,
        name: String,
        description: String,
        hardware: String,
        visibility: ReplicateModelVisibility
    ) async throws -> URL {
        // From replicate docs: "Note that it doesn’t matter which hardware you pick for your
        // model at this time, because we route to H100s for all our FLUX.1 fine-tunes"
        let requestBody = ReplicateCreateModelRequestBody(
            description: description,
            hardware: hardware,
            name: name,
            owner: owner,
            visibility: visibility
        )

        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models",
            body: requestBody.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        let responseModel = try ReplicateModelResponseBody.deserialize(from: data)
        guard let url = responseModel.url else {
            throw ReplicateError.missingModelURL
        }
        return url
    }

    /// Train a model
    ///
    /// - Parameters:
    ///
    ///   - modelOwner:  This is not your replicate account. Set this to the owner of the fine-tuning trainer, e.g. `ostris`.
    ///
    ///   - modelName: The name of the trainer, e.g. `flux-dev-lora-trainer`.
    ///
    ///   - versionID: The version of the trainer to run.
    ///
    ///   - body: The training request body, parametrized by T where T is a decodable input that you define.
    ///
    /// - Returns: The training response, which contains a URL to poll for the training progress
    public func createTraining<T>(
        modelOwner: String,
        modelName: String,
        versionID: String,
        body: ReplicateTrainingRequestBody<T>
    ) async throws -> ReplicateTrainingResponseBody {
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/versions/\(versionID)/trainings",
            body: body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try ReplicateTrainingResponseBody.deserialize(from: data)
    }

    /// Get the current state of a training.
    ///
    /// If you need to poll for the training to complete, see `pollForTrainingResult` defined below.
    ///
    /// - Parameters:
    ///   - url: The URL returned as part of a `createTraining` request
    ///
    /// - Returns: The training response body
    public func getTraining(
        url: URL
    ) async throws -> ReplicateTrainingResponseBody {
        guard url.host == "api.replicate.com" else {
            throw AIProxyError.assertion("Replicate has changed the poll domain")
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
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Uploads a file to replicate's CDN.
    ///
    /// - Parameters:
    ///   - contents: The binary contents of your file. If you've added your file to xcassets, you
    ///               can access the file's data with `NSDataAsset(name: "myfile").data`
    ///   - contentType: The mime type of the file, e.g. "application/zip"
    ///   - name: The name of the file, e.g. `myfile.zip`
    ///
    /// - Returns: The file upload response body, which contains the file's URL on Replicate's network.
    ///            You can pass this URL to subsequent inference and training jobs.
    public func uploadFile(
        contents: Data,
        contentType: String,
        name: String
    ) async throws -> ReplicateFileUploadResponseBody {
        let body = ReplicateFileUploadRequestBody(
            contents: contents,
            contentType: contentType,
            fileName: name
        )
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/files",
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: 60,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }
}

private func mapBase64DataURIsToData(_ dataURIs: [String]) -> [Data] {
    return dataURIs.map {
        mapBase64DataURIToData($0)
    }.compactMap { $0 }
}

private func mapBase64DataURIToData(_ dataURI: String) -> Data? {
    return dataURI.split(separator: ",").last.flatMap { Data(base64Encoded: String($0)) }
}
