//
//  ReplicateProxiedService.swift
//
//  Created by Lou Zell on 8/23/24.
//

import Foundation

private let kTimeoutBufferForSyncAPIInSeconds: TimeInterval = 5

open class ReplicateProxiedService: ReplicateService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.replicateService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// This is the general purpose method for running official replicate models.
    /// It is generic in the input and output, so it's up to you to pass appropriate types.
    /// To craft the appropriate types, look at the model's schema on replicate.
    /// You can find the schema by browsing to the model and tapping on `API` in the top nav and then `Schema` in the side nav.
    /// If the output schema is a `URI`, for example, you can call this with:
    ///
    ///     let myPredictionResult: ReplicateSynchronousAPIOutput<URL> = replicateService.createSynchronousPredictionUsingOfficialModel(...)
    ///     let myURL = myPredictionResult.output
    ///
    /// note the specialization of `<URL>` in the type annotation.
    ///
    /// There are convenience methods for running specific replicate models lower in this file, which are easier to call and
    /// not generic. You can use those for guidance on how to call this general purpose method with your own model.
    ///
    /// Makes a POST request to the 'create a prediction using an official model' endpoint described here:
    /// https://replicate.com/docs/reference/http#create-a-prediction-using-an-official-model
    ///
    /// Uses the synchronous API announced here: https://replicate.com/changelog/2024-10-09-synchronous-api
    ///
    /// - Parameters:
    ///
    ///   - modelOwner: The owner of the model
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The inference results wrapped in ReplicateSynchronousAPIOutput
    public func createSynchronousPredictionUsingOfficialModel<T: Encodable, U: Encodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        secondsToWait: Int
    )  async throws -> ReplicateSynchronousAPIOutput<U> {
        let requestBody = ReplicatePredictionRequestBody(input: input)
        var request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: requestBody.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: ["Prefer": "wait=\(secondsToWait)"]
        )
        request.timeoutInterval = TimeInterval(secondsToWait) + kTimeoutBufferForSyncAPIInSeconds
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// This is the general purpose method for running community replicate models.
    /// It is generic in the input and output, so it's up to you to pass appropriate types.
    /// To craft the appropriate types, look at the model's schema on replicate.
    /// You can find the schema by browsing to the model and tapping on `API` in the top nav and then `Schema` in the side nav.
    /// If the output schema is a `URI`, for example, you can call this with:
    ///
    ///     let myPredictionResult: ReplicateSynchronousAPIOutput<URL> = replicateService.createSynchronousPredictionUsingVersion(...)
    ///     let myURL = myPredictionResult.output
    ///
    /// note the specialization of `<URL>` in the type annotation.
    ///
    /// Makes a POST request to the 'create a prediction using community model' endpoint described here:
    /// https://replicate.com/docs/reference/http#predictions.create
    ///
    /// Uses the synchronous API announced here: https://replicate.com/changelog/2024-10-09-synchronous-api
    ///
    /// - Parameters:
    ///
    ///   - modelVersion: The version of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The inference results wrapped in ReplicateSynchronousAPIOutput
    public func createSynchronousPredictionUsingVersion<T: Encodable, U: Encodable>(
        modelVersion: String,
        input: T,
        secondsToWait: Int
    )  async throws -> ReplicateSynchronousAPIOutput<U> {
        let requestBody = ReplicatePredictionRequestBody(
            input: input,
            version: modelVersion
        )
        var request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: requestBody.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: ["Prefer": "wait=\(secondsToWait)"]
        )
        request.timeoutInterval = TimeInterval(secondsToWait) + kTimeoutBufferForSyncAPIInSeconds
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Prefer `createSynchronousPredictionUsingOfficialModel` to this method.
    ///
    /// Makes a POST request to the 'create a prediction using an official model' endpoint described here:
    /// https://replicate.com/docs/reference/http#create-a-prediction-using-an-official-model
    ///
    /// - Parameters:
    ///
    ///   - modelOwner: The owner of the model
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    ///   - output: The output schema, for example `ReplicateFluxSchnellOutputSchema`
    ///
    /// - Returns: A prediction object that contains a `url` that can be queried using the
    ///            `getPredictionResult` method or `pollForPredictionResult` method.
    public func createPredictionUsingOfficialModel<T: Encodable, U: Decodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        output: U.Type
    )  async throws -> U {
        let requestBody = ReplicatePredictionRequestBody(input: input)
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: requestBody.serialize(),
            verb: .post,
            contentType: "application/json"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try output.deserialize(from: data)
    }


    /// Prefer `createSynchronousPredictionUsingVersion` to this method.
    ///
    /// Makes a POST request to the 'create a prediction' endpoint described here:
    /// https://replicate.com/docs/reference/http#create-a-prediction
    ///
    /// - Parameters:
    ///
    ///   - version: The version of the model that you would like to create a prediction
    ///
    ///   - input: The input schema, for example `ReplicateSDXLInputSchema`
    ///
    ///   - output: The output schema, for example `ReplicateSDXLOutputSchema`
    ///
    /// - Returns: A prediction object that contains a `url` that can be queried using the
    ///            `getPredictionResult` method or `pollForPredictionResult` method.
    public func createPrediction<T: Encodable, U: Decodable>(
        version: String,
        input: T,
        output: U.Type
    )  async throws -> U {
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
            contentType: "application/json"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try output.deserialize(from: data)
    }

    /// Queries for a prediction result a single time.
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createPrediction` request
    ///
    ///   - output: The decodable to map the returned response to. This is likely a
    ///             ReplicatePredictionResponseBody specialized by the output schema of your model,
    ///             e.g. ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>
    /// - Returns: The prediction response body
    public func getPredictionResult<U: Decodable>(
        url: URL,
        output: U.Type
    ) async throws -> U {
        guard url.host == "api.replicate.com" else {
            throw AIProxyError.assertion("Replicate has changed the poll domain")
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: url.path,
            body: nil,
            verb: .get
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try output.deserialize(from: data)
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

    /// Uploads a zip file to replicate for use in training Flux fine-tunes.
    /// For instructions on what to place in the zip file, see the "prepare your training data"
    /// of this guide: https://replicate.com/blog/fine-tune-flux
    ///
    /// - Parameters:
    ///
    ///   - zipData: The binary contents of your zip file. If you've added your zip file to xcassets, you
    ///              can access the file's data with `NSDataAsset(name: "myfile").data`
    ///
    ///   - name: The name of the zip file, e.g. `myfile.zip`
    ///
    /// - Returns: The file upload response body, which contains a URL for where your zip file lives on
    ///            replicate's network. You can pass this URL to training jobs.
    public func uploadTrainingZipFile(
        zipData: Data,
        name: String
    ) async throws -> ReplicateFileUploadResponseBody {
        let body = ReplicateFileUploadRequestBody(fileData: zipData, fileName: name)
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/files",
            body: formEncode(body, boundary),
            verb: .post,
            contentType: "multipart/form-data; boundary=\(boundary)"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try ReplicateFileUploadResponseBody.deserialize(from: data)
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
            contentType: "application/json"
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try ReplicateTrainingResponseBody.deserialize(from: data)
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
