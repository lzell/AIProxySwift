//
//  ReplicateService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

// ---------------------------------------------------------------------------------
//                                 Attention!
//
//                  Please start in ReplicateService+Convenience.swift
//
//  If your use-case is not satisfied there, use the implementations in that file as
//  inspiration to write your own implementation using the generic methods below
// ---------------------------------------------------------------------------------

public protocol ReplicateService {

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
    ///   - modelOwner: The model owner. This is not your account name.
    ///               The owner is displayed in the URL of the model you are trying to call
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The inference results wrapped in ReplicateSynchronousAPIOutput
    func createSynchronousPredictionUsingOfficialModel<T: Encodable, U: Decodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        secondsToWait: Int
    )  async throws -> ReplicateSynchronousResponseBody<U>

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
    func createSynchronousPredictionUsingVersion<T: Encodable, U: Decodable>(
        modelVersion: String,
        input: T,
        secondsToWait: Int
    ) async throws -> ReplicateSynchronousResponseBody<U>

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
    func createPredictionUsingOfficialModel<T: Encodable, U: Decodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        output: U.Type
    )  async throws -> U

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
    func createPrediction<T: Encodable, U: Decodable>(
        version: String,
        input: T,
        output: U.Type
    ) async throws -> U

    /// Queries for a prediction result a single time
    ///
    /// Prefer the synchronous API before reaching for this.
    /// See `createSynchronousPredictionUsingOfficialModel` and `createSynchronousPredictionUsingVersion`
    ///
    /// If you need to poll for the prediction output, see `pollForPredictionOutput` defined below.
    ///
    /// - Parameters:
    ///   - url: The polling URL returned as part of a `createPrediction` request
    ///
    ///   - output: The decodable to map the returned response to. This is likely a
    ///             ReplicatePredictionResponseBody specialized by the output schema of your model,
    ///             e.g. ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>
    /// - Returns: The prediction response body
    func getPredictionResult<U: Decodable>(
        url: URL,
        output: U.Type
    ) async throws -> U

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
    func createModel(
        owner: String,
        name: String,
        description: String,
        hardware: String,
        visibility: ReplicateModelVisibility
    ) async throws -> URL

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
    func uploadTrainingZipFile(
        zipData: Data,
        name: String
    ) async throws -> ReplicateFileUploadResponseBody

    /// Train a model. See the companion method `pollForTrainingResult` defined in this file.
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
    func createTraining<T>(
        modelOwner: String,
        modelName: String,
        versionID: String,
        body: ReplicateTrainingRequestBody<T>
    ) async throws -> ReplicateTrainingResponseBody
}


extension ReplicateService {

    /// Prefer the `createSynchronousPredictionUsingOfficialModel` method instead of this method.
    /// If your model does not support the synchronous API, then you can use this as a fallback.
    /// Grep this codebase for `predictAndPollUsingOfficialModel` to see examples of satisfying T and U.
    ///
    /// - Parameters:
    ///   - modelOwner: The model owner. This is not your account name.
    ///                 The owner is displayed in the URL of the model you are trying to call
    ///
    ///   - modelName: The model name
    ///
    ///   - input: An encodable input. The input will be serialized and sent as JSON to replicate's HTTP API.
    ///
    ///   - pollAttempts: Number of times to poll for the inference result before `ReplicateError.reachedRetryLimit` is thrown..
    ///
    ///   - secondsBetweenPollAttempts: Seconds between poll attempts
    /// - Returns: The deserialized response body containing the inference result.
    public func predictAndPollUsingOfficialModel<T: Encodable, U: Decodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> U {
        let predictionResponse = try await self.createPredictionUsingOfficialModel(
            modelOwner: modelOwner,
            modelName: modelName,
            input: input,
            output: ReplicatePredictionResponseBody<U>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Prefer the `createSynchronousPredictionUsingVersion` method instead of this method.
    /// If your model does not support the synchronous API, then you can use this as a fallback.
    /// Grep this codebase for `predictAndPollUsingVersion` to see examples of satisfying T and U.
    ///
    /// - Parameters:
    ///   - version: The model version GUID. You can find this string by tapping on the 'HTTP API'  card on the model's detail page
    ///
    ///   - input: An encodable input. The input will be serialized and sent as JSON to replicate's HTTP API.
    ///
    ///   - pollAttempts: Number of times to poll for the inference result before `ReplicateError.reachedRetryLimit` is thrown..
    ///
    ///   - secondsBetweenPollAttempts: Seconds between poll attempts
    /// - Returns: The deserialized response body containing the inference result.
    public func predictAndPollUsingVersion<T: Encodable, U: Decodable>(
        version: String,
        input: T,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> U {
        let predictionResponse = try await self.createPrediction(
            version: version,
            input: input,
            output: ReplicatePredictionResponseBody<U>.self
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Polls for the output, `T`, of a prediction request created with `createPrediction`
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
        secondsBetweenPollAttempts: UInt64
    ) async throws -> T {
        guard let pollURL = predictionResponse.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }
        let pollResult: ReplicatePredictionResponseBody<T> = try await self.pollForPredictionResult(
            url: pollURL,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
        guard let output = pollResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
    }

    /// Polls for the result of a `createPrediction` request
    ///
    /// Prefer the synchronous API before reaching for this.
    /// See `createSynchronousPredictionUsingOfficialModel` and `createSynchronousPredictionUsingVersion`
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
    public func pollForPredictionResult<U: Decodable>(
        url: URL,
        numTries: Int,
        nsBetweenPollAttempts: UInt64
    ) async throws -> ReplicatePredictionResponseBody<U> {
        try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        for _ in 0..<numTries {
            let response = try await self.getPredictionResult(
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

    /// Polls for the result of a `createTraining` request
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createTraining` request
    ///
    ///   - numTries: The number of attempts to poll for a completed training before `ReplicateError.reachedRetryLimit` is thrown.
    ///
    /// - Returns: The completed prediction response body
    public func pollForTrainingResult(
        url: URL,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64 = 10
    ) async throws -> ReplicateTrainingResponseBody {
        try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getPredictionResult(
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
                try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
            }
        }
        throw ReplicateError.reachedRetryLimit
    }

    /// See the usage examples in ReplicateService+Convenience.
    public func synchronousResponseBodyToOutput<T>(_ responseBody: ReplicateSynchronousResponseBody<T>) async throws -> T {
        if let error = responseBody.error {
            throw ReplicateError.predictionFailed(error)
        }

        // If the sync API returned the inference output as part of the initial response, return it
        if let output = responseBody.output {
            return output
        }

        // Otherwise, fall back to making a request to `predictionResultURL`
        guard let predictionResultURL = responseBody.predictionResultURL else {
            throw ReplicateError.predictionFailed("Replicate prediction did not include a result URL.")
        }

        let prediction = try await self.getPredictionResult(
            url: predictionResultURL,
            output: ReplicatePredictionResponseBody<T>.self
        )

        guard let predictionOutput = prediction.output else {
            throw ReplicateError.predictionFailed("""
                Your replicate prediction failed. This could be due to a number of reasons:
                1. Your `secondsToWait` is not long enough for the generation to complete
                2. You are trying to use the replicate sync API for a model that doesn't support it
                3. The replicate API is having stability problems
                4. The replicate model that you are trying to call was removed
                """
            )
        }

        return predictionOutput
    }
}
