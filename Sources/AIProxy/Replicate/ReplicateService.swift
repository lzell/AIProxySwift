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

@AIProxyActor public protocol ReplicateService: Sendable {

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
    func createSynchronousPredictionUsingOfficialModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: Input,
        secondsToWait: UInt
    )  async throws -> ReplicatePrediction<Output>

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
    func createSynchronousPredictionUsingCommunityModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelVersion: String,
        input: Input,
        secondsToWait: UInt
    ) async throws -> ReplicatePrediction<Output>


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
    func createPredictionUsingOfficialModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: Input
    ) async throws -> ReplicatePrediction<Output>

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
    func createPredictionUsingCommunityModel<Input: Encodable & Sendable, Output: Decodable & Sendable>(
        version: String,
        input: Input
    ) async throws -> ReplicatePrediction<Output>

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
    func getPrediction<Output: Decodable & Sendable>(
        url: URL
    ) async throws -> ReplicatePrediction<Output>

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
    func createTraining<T: Sendable>(
        modelOwner: String,
        modelName: String,
        versionID: String,
        body: ReplicateTrainingRequestBody<T>
    ) async throws -> ReplicateTrainingResponseBody

    /// Get the current state of a training.
    ///
    /// If you need to poll for the training to complete, see `pollForTrainingResult` defined below.
    ///
    /// - Parameters:
    ///   - url: The URL returned as part of a `createTraining` request
    ///
    /// - Returns: The training response body
    func getTraining(
        url: URL
    ) async throws -> ReplicateTrainingResponseBody

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
    func uploadFile(
        contents: Data,
        contentType: String,
        name: String
    ) async throws -> ReplicateFileUploadResponseBody
}

extension ReplicateService {

    /// Runs an official replicate model and waits for the prediction to reach a terminal state.
    /// The returned prediction will have a status in the terminal state (one of  `.succeeded`, `.failed`, or `.canceled`).
    /// If we can't get a response body in a terminal state before `secondsToWait`, then `ReplicateError.reachedRetryLimit` is raised.
    ///
    /// Internally, this method starts with the synchronous API and then falls back to polling if the prediction has not completed
    /// within sixty seconds.
    ///
    /// # Usage
    ///
    ///     let input = ReplicateFluxSchnellInputSchema(...)
    ///     let prediction: ReplicatePrediction<[URL]> = try await replicateService.runOfficialModel(
    ///         modelOwner: "black-forest-labs",
    ///         modelName: "flux-schnell",
    ///         input: input,
    ///         secondsToWait: secondsToWait
    ///     )
    ///     let urls = try await replicateService.getPredictionOutput(prediction)
    ///
    /// - Returns the ReplicatePrediction in a terminal state
    public func runOfficialModel<T: Encodable & Sendable, Output: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: T,
        secondsToWait: UInt
    )  async throws -> ReplicatePrediction<Output> {
        let syncSecondsToWait = self.safeSecondsToWait(secondsToWait)
        let responseBody: ReplicatePrediction<Output> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: modelOwner,
            modelName: modelName,
            input: input,
            secondsToWait: syncSecondsToWait
        )
        return try await self.transitionFromSyncToPollingAPIIfNecessary(responseBody, secondsToWait, syncSecondsToWait)
    }

    /// Runs a community replicate model and waits for the prediction to reach a terminal state.
    /// The returned prediction will have a status in the terminal state (one of  `.succeeded`, `.failed`, or `.canceled`).
    /// If we can't get a response body in a terminal state before `secondsToWait`, then `ReplicateError.reachedRetryLimit` is raised.
    ///
    /// Internally, this method starts with the synchronous API and then falls back to polling if the prediction has not completed
    /// within sixty seconds.
    ///
    /// # Usage
    ///
    ///     let input = ReplicateSDXLInputSchema(...)
    ///     let prediction: ReplicatePrediction<[URL]> = try await replicateService.runCommunityModel(
    ///         version: "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
    ///         input: input,
    ///         secondsToWait: secondsToWait
    ///     )
    ///     let urls = try await replicateService.getPredictionOutput(prediction)
    ///
    /// - Returns the ReplicatePrediction in a terminal status
    public func runCommunityModel<T: Encodable & Sendable, Output: Decodable & Sendable>(
        version: String,
        input: T,
        secondsToWait: UInt
    )  async throws -> ReplicatePrediction<Output> {
        let syncSecondsToWait = self.safeSecondsToWait(secondsToWait)
        let responseBody: ReplicatePrediction<Output> = try await self.createSynchronousPredictionUsingCommunityModel(
            modelVersion: version,
            input: input,
            secondsToWait: syncSecondsToWait
        )
        return try await self.transitionFromSyncToPollingAPIIfNecessary(responseBody, secondsToWait, syncSecondsToWait)
    }

    /// Polls until the prediction reaches a terminal state (succeeded, failed, or canceled)
    ///
    /// Please see `runOfficialModel` and `runCommunityModel` before reaching for this.
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createPrediction` request
    ///
    ///   - pollAttempts: The number of attempts to poll for a completed prediction before `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between polls
    ///
    /// - Returns: The completed prediction response body
    public func pollForPredictionCompletion<Output: Decodable & Sendable>(
        url: URL,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> ReplicatePrediction<Output> {
        try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response: ReplicatePrediction<Output> = try await self.getPrediction(
                url: url
            )
            if response.status?.isTerminal == true {
                return response
            }
            try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        }
        throw ReplicateError.reachedRetryLimit
    }

    /// Polls until the training reaches a terminal state (succeeded, failed, or canceled)
    ///
    /// - Parameters:
    ///
    ///   - url: The polling URL returned as part of a `createTraining` request
    ///
    ///   - pollAttempts: The number of attempts to poll for a completed training before `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between polls
    ///
    /// - Returns: The completed training response body
    public func pollForTrainingCompletion(
        url: URL,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> ReplicateTrainingResponseBody {
        try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getTraining(url: url)
            if response.status?.isTerminal == true {
                return response
            }
            try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        }
        throw ReplicateError.reachedRetryLimit
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
        return try await self.uploadFile(
            contents: zipData,
            contentType: "application/zip",
            name: name
        )
    }

    /// See the usage examples in ReplicateService+Convenience.
    public func getPredictionOutput<Output: Decodable & Sendable>(
        _ responseBody: ReplicatePrediction<Output>
    ) async throws -> Output {
        if let error = responseBody.error {
            throw ReplicateError.predictionFailed(error)
        }

        // If the sync API returned the inference output as part of the initial response, return it
        if let output = responseBody.output {
            return output
        }

        // Otherwise, fall back to making a request to `predictionResultURL`
        guard let predictionResultURL = responseBody.urls?.get else {
            throw ReplicateError.predictionFailed("Replicate prediction did not include a result URL.")
        }

        let prediction: ReplicatePrediction<Output> = try await self.getPrediction(
            url: predictionResultURL
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

    private func transitionFromSyncToPollingAPIIfNecessary<Output: Decodable & Sendable>(
        _ prediction: ReplicatePrediction<Output>,
        _ secondsToWait: UInt,
        _ secondsElapsed: UInt
    ) async throws -> ReplicatePrediction<Output> {
        // In the happy path, the prediction completed in the time allotted by the sync API.
        // There is a bug in the sync API here. We can't just check to see if the `responseBody.status?.isTerminal == true`,
        // because the sync API often returns predictions with the status still in `processing`, even though the prediction
        // has finished and the `output` field is populated. Instead, we'll check for the presence of `output`.
        if prediction.output != nil {
            return prediction
        }

        guard secondsToWait - secondsElapsed >= 1 else {
            throw ReplicateError.reachedRetryLimit
        }

        guard let pollURL = prediction.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }

        let remainingTime = secondsToWait - secondsElapsed
        let numberOfPollAttempts = UInt(remainingTime + 9) / 10
        return try await self.pollForPredictionCompletion(
            url: pollURL,
            pollAttempts: numberOfPollAttempts,
            secondsBetweenPollAttempts: 10
        )
    }
}


extension ReplicateService {
    internal func safeSecondsToWait(_ secondsToWait: UInt, warn: Bool = false) -> UInt {
        if secondsToWait > 60 && warn {
            logIf(.warning)?.warning(
                """
                The replicate sync API can not wait longer than 60 seconds.
                Please use the convenience method XYZ, which will fall back to polling after 60 seconds ellapses.
                """
            )
        }
        return min(60, secondsToWait)
    }
}


// MARK: - Deprecated
extension ReplicateService {

    @available(*, deprecated, message: "Use createSynchronousPredictionUsingCommunityModel")
    func createSynchronousPredictionUsingVersion<T: Encodable & Sendable, U: Decodable & Sendable>(
        modelVersion: String,
        input: T,
        secondsToWait: UInt
    ) async throws -> ReplicatePrediction<U> {
        return try await self.createSynchronousPredictionUsingCommunityModel(
            modelVersion: modelVersion,
            input: input,
            secondsToWait: secondsToWait
        )
    }

    @available(*, deprecated, message: "Use createPredictionUsingCommunityModel")
    public func createPrediction<T: Encodable & Sendable, Output: Decodable & Sendable>(
        version: String,
        input: T
    ) async throws -> ReplicatePrediction<Output> {
        return try await self.createPredictionUsingCommunityModel(version: version, input: input)
    }

    @available(*, deprecated, message: "Use createPredictionUsingCommunityModel")
    public func createPrediction<T: Encodable & Sendable, Output: Decodable & Sendable>(
        version: String,
        input: T,
        output: ReplicatePredictionResponseBody<Output>.Type
    ) async throws -> ReplicatePrediction<Output> {
        return try await self.createPredictionUsingCommunityModel(version: version, input: input)
    }

    @available(*, deprecated, message: "Use getPrediction")
    public func getPredictionResult<Output: Decodable & Sendable>(
        url: URL
    ) async throws -> ReplicatePrediction<Output> {
        return try await self.getPrediction(url: url)
    }

    @available(*, deprecated, message: "Please use runOfficialModel instead")
    public func predictAndPollUsingOfficialModel<T: Encodable & Sendable, U: Decodable & Sendable>(
        modelOwner: String,
        modelName: String,
        input: T,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> U {
        let predictionResponse: ReplicatePrediction<U> = try await self.createPredictionUsingOfficialModel(
            modelOwner: modelOwner,
            modelName: modelName,
            input: input
        )
        guard let url = predictionResponse.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }
        let completedResponse: ReplicatePrediction<U> = try await self.pollForPredictionCompletion(
            url: url,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
        return try await self.synchronousResponseBodyToOutput(completedResponse)
    }

    @available(*, deprecated, message: "Please use runCommunityModel instead")
    public func predictAndPollUsingVersion<T: Encodable & Sendable, U: Decodable & Sendable>(
        version: String,
        input: T,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> U {
        let predictionResponse: ReplicatePrediction<U> = try await self.createPrediction(
            version: version,
            input: input
        )
        return try await self.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    @available(*, deprecated, message: "Use getPredictionOutput")
    public func synchronousResponseBodyToOutput<Output: Decodable & Sendable>(
        _ responseBody: ReplicatePrediction<Output>
    ) async throws -> Output {
        return try await self.getPredictionOutput(responseBody)
    }

    @available(*, deprecated, message: "Use pollForPredictionCompletion instead")
    public func pollForPredictionResult<U: Decodable & Sendable>(
        url: URL,
        numTries: UInt,
        nsBetweenPollAttempts: UInt
    ) async throws -> ReplicatePrediction<U> {
        try await Task.sleep(nanoseconds: UInt64(nsBetweenPollAttempts))
        for _ in 0..<numTries {
            let response: ReplicatePrediction<U> = try await self.getPredictionResult(
                url: url
            )
            switch response.status {
            case .canceled:
                throw ReplicateError.predictionCanceled
            case .failed:
                throw ReplicateError.predictionFailed(response.error)
            case .succeeded:
                return response
            case .none, .processing, .starting:
                try await Task.sleep(nanoseconds: UInt64(nsBetweenPollAttempts))
            }
        }
        throw ReplicateError.reachedRetryLimit
    }

    /// Please use `pollForPredictionCompletion` in place of this method.
    ///
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
    @available(*, deprecated, message: "Use pollForPredictionCompletion instead")
    public func pollForPredictionOutput<T>(
        predictionResponse: ReplicatePrediction<T>,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt
    ) async throws -> T {
        guard let pollURL = predictionResponse.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }
        let pollResult: ReplicatePrediction<T> = try await self.pollForPredictionResult(
            url: pollURL,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
        guard let output = pollResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
    }

    @available(*, deprecated, message: "Use pollForTrainingCompletion instead")
    public func pollForTrainingResult(
        url: URL,
        pollAttempts: UInt,
        secondsBetweenPollAttempts: UInt = 10
    ) async throws -> ReplicateTrainingResponseBody {
        try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getTraining(url: url)
            print("AIProxy: polled replicate training. Current status: \(response.status?.rawValue ?? "none")")
            switch response.status {
            case .canceled:
                throw ReplicateError.predictionCanceled
            case .failed:
                throw ReplicateError.predictionFailed(response.error)
            case .succeeded:
                return response
            case .none, .processing, .starting:
                try await Task.sleep(nanoseconds: UInt64(secondsBetweenPollAttempts) * 1_000_000_000)
            }
        }
        throw ReplicateError.reachedRetryLimit
    }
}
