//
//  ReplicateService.swift
//
//  Created by Lou Zell on 8/23/24.
//

import Foundation


public final class ReplicateService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of ReplicateService. Note that the initializer is not public.
    /// Customers are expected to use the factory `AIProxy.replicateService` defined in AIProxy.swift
    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// This is a convenience method for creating an image through Black Forest Lab's Flux-Schnell model:
    /// https://replicate.com/black-forest-labs/flux-schnell
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxSchnellInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. Each poll is separated by 1
    ///                   second. The default is to try to fetch the resulting image for up to 30 seconds,
    ///                   after which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: An array of image URLs
    public func createFluxSchnellImage(
        input: ReplicateFluxSchnellInputSchema,
        pollAttempts: Int = 30
    ) async throws -> [URL] {
        let predictionResponse = try await self.createPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateFluxSchnellOutputSchema>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
        )
    }

    /// This is a convenience method for creating an image through Black Forest Lab's Flux-Pro model:
    /// https://replicate.com/black-forest-labs/flux-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxProInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. Each poll is separated by 1
    ///                   second. The default is to try to fetch the resulting image for up to 30 seconds,
    ///                   after which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: An image URL
    public func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        pollAttempts: Int = 30
    ) async throws -> URL {
        let predictionResponse = try await self.createPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-pro",
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateFluxProOutputSchema>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
        )
    }

    /// This is a convenience method for creating an image through Black Forest Lab's Flux-Dev model:
    /// https://replicate.com/black-forest-labs/flux-dev
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxDevInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. Each poll is separated by 1
    ///                   second. The default is to try to fetch the resulting image for up to 30 seconds,
    ///                   after which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: An array of image URLs
    public func createFluxDevImage(
        input: ReplicateFluxDevInputSchema,
        pollAttempts: Int = 30
    ) async throws -> [URL] {
        let predictionResponse = try await self.createPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-dev",
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateFluxDevOutputSchema>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
        )
    }

    public func createFluxPulidImage(
        input: ReplicateFluxPulidInputSchema,
        version: String = "8baa7ef2255075b46f4d91cd238c21d31181b3e6a864463f967960bb0112525b",
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> [URL] {
        let predictionResponse = try await self.createPrediction(
            version: version,
            input: input,
            output: ReplicatePredictionResponseBody<[URL]>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// This is a convenience method for creating an image through StabilityAI's SDXL model.
    /// https://replicate.com/stability-ai/sdxl
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. Each poll is separated by 1
    ///                   second. The default is to try to fetch the resulting image for up to 60 seconds,
    ///                   after which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: An array of image URLs
    public func createSDXLImage(
        input: ReplicateSDXLInputSchema,
        version: String = "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
        pollAttempts: Int = 60
    ) async throws -> [URL] {
        let predictionResponse = try await self.createPrediction(
            version: version,
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
        )
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
        hardware: String? = nil,
        visibility: ReplicateModelVisibility = .private
    ) async throws -> URL {
        // From replicate docs: "Note that it doesn’t matter which hardware you pick for your
        // model at this time, because we route to H100s for all our FLUX.1 fine-tunes"
        let requestBody = ReplicateCreateModelRequestBody(
            description: description,
            hardware: hardware ?? "gpu-t4",
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

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
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

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)
        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

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
        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
        return try ReplicateTrainingResponseBody.deserialize(from: data)
    }

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
        let encoder = JSONEncoder()
        let body = try encoder.encode(
            ReplicatePredictionRequestBody(
                input: input
            )
        )
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: body,
            verb: .post,
            contentType: "application/json"
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try JSONDecoder().decode(output, from: data)
    }

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
        let encoder = JSONEncoder()
        let body = try encoder.encode(
            ReplicatePredictionRequestBody(
                input: input,
                version: version
            )
        )
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: body,
            verb: .post,
            contentType: "application/json"
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try JSONDecoder().decode(output, from: data)
    }

    /// Polls for the output, `T`, of a prediction request.
    /// For an example of how to call this generic method, see the convenience method `createFluxProImage`.
    ///
    /// - Parameters:
    ///
    ///   - predictionResponse: The response from the `createPrediction` request
    ///
    ///   - pollAttempts: The number of attempts to poll for a completed prediction. Each poll is separated by 1
    ///               second. The default is to try to fetch the resulting image for up to 60 seconds, after
    ///               which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: The completed prediction response body
    public func pollForPredictionOutput<T>(
        predictionResponse: ReplicatePredictionResponseBody<T>,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64 = 1
    ) async throws -> T {
        guard let pollURL = predictionResponse.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }
        let pollResult: ReplicatePredictionResponseBody<T> = try await self.actorPollForPredictionResult(
            url: pollURL,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
        guard let output = pollResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
    }

    public func pollForTrainingComplete(
        url: URL,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64 = 10
    ) async throws -> ReplicateTrainingResponseBody {
        return try await self.actorPollForTrainingResult(
            url: url,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
    }

    /// Polls for the result of a prediction request on the AIProxy Network Actor.
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createPrediction` request
    ///
    ///   - numTries: The number of attempts to poll for a completed prediction. Each poll is separated by 1
    ///               second. The default is to try to fetch the resulting image for up to 60 seconds, after
    ///               which ReplicateError.reachedRetryLimit will be thrown.
    ///
    /// - Returns: The completed prediction response body
    @NetworkActor
    private func actorPollForPredictionResult<U: Decodable>(
        url: URL,
        numTries: Int,
        nsBetweenPollAttempts: UInt64 = 1_000_000_000
    ) async throws -> ReplicatePredictionResponseBody<U> {
        try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        for _ in 0..<numTries {
            let response = try await self.actorGetPredictionResult(
                url: url,
                output: ReplicatePredictionResponseBody<U>.self
            )
            switch response.status {
            case .canceled:
                throw ReplicateError.predictionCanceled
            case .failed:
                throw ReplicateError.predictionFailed(response.error)
            case .succeeded:
                return response
            case .none, .processing, .starting:
                try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
            }
        }
        throw ReplicateError.reachedRetryLimit
    }

    @NetworkActor
    private func actorPollForTrainingResult(
        url: URL,
        numTries: Int,
        nsBetweenPollAttempts: UInt64
    ) async throws -> ReplicateTrainingResponseBody {
        try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        for _ in 0..<numTries {
            let response = try await self.actorGetPredictionResult(
                url: url,
                output: ReplicateTrainingResponseBody.self
            )
            print("AIProxy: polled replicate training. Current status: \(response.status?.rawValue ?? "none")")
            switch response.status {
            case .canceled:
                throw ReplicateError.predictionCanceled
            case .failed:
                throw ReplicateError.predictionFailed(response.error)
            case .succeeded:
                return response
            case .none, .processing, .starting:
                try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
            }
        }
        throw ReplicateError.reachedRetryLimit
    }

    /// Queries for a prediction result a single time on the AIProxy Network Actor.
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createPrediction` request
    ///
    ///   - output: The decodable to map the returned response to. This is likely a
    ///             ReplicatePredictionResponseBody specialized by the output schema of your model,
    ///             e.g. ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>
    /// - Returns: The prediction response body
    @NetworkActor
    private func actorGetPredictionResult<U: Decodable>(
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
        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)
        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
        return try output.deserialize(from: data)
    }
}
