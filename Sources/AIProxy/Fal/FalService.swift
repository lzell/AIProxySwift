//
//  FalService.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

// ---------------------------------------------------------------------------------
//                                 Attention!
//
//                  Please start in FalService+Convenience.swift
//
//  If your use-case is not satisfied there, use the implementations in that file as
//  inspiration to write your own implementation using the generic methods below
// ---------------------------------------------------------------------------------

@AIProxyActor public protocol FalService: Sendable {

    /// Creates an inference on Fal. The returned value contains a URL that you can check for
    /// the status of your inference..
    ///
    /// You may want to start in `FalService+Convenience.swift` to see if there is already a
    /// convenience function for your use case. If there is not, use the method bodies in that file as
    /// inspiration to build your own using this method and the polling methods below.
    func createInference<T: Encodable>(
        model: String,
        input: T
    ) async throws -> FalQueueResponseBody

    /// Gets the response object from a completed inference. The URL to pass is the
    /// `response_url` described here: https://fal.ai/docs/model-endpoints/queue
    ///
    /// You should only call this method once `pollForInferenceComplete` returns, which is defined below.
    ///
    /// - Parameter url: The `responseURL` that is returned as part of `FalQueueResponseBody`
    ///
    /// - Returns: A decodable type that you define to match your model's "output schema". To find the
    ///            output schema, navigate to the model on Fal, then tap on "API" and scroll down until
    ///            you find the "Output" section. Here is an example:
    ///            https://fal.ai/models/fal-ai/fast-sdxl/api#schema-output
    func getResponse<T: Decodable & Sendable>(
        url: URL
    ) async throws -> T

    /// Uploads a file to Fal's short term storage for use in a subsequent call. For example,
    /// you can upload an image to short term storage that you then use as input to ControlNet.
    ///
    /// - Parameters:
    ///   - fileData: The binary representation of your file
    ///   - name: name of the file
    ///   - contentType: Content-type, e.g. `image/png` for PNG files or `application/zip` for zip files
    /// - Returns: The URL of the file on Fal's short term storage.
    func uploadFile(
        fileData: Data,
        name: String,
        contentType: String
    ) async throws -> URL

}

extension FalService {
    /// Use this helper to kick off an inference request and wait for the result to be available.
    /// - Parameters:
    ///   - model: The model to run
    ///   - input: The input schema of the model.
    ///            Find this by browing to your model on fal and tapping on "API" then "Schema > Input" in the left sidebar
    ///   - pollAttempts: The number of poll attempts to make before raising FalError.reachedRetryLimit
    ///   - secondsBetweenPollAttempts: Seconds between poll attempts. Set this so that `pollAttempts * secondsBetweenPollAttempts`
    ///                                 is the longest you'd like to wait for a result.
    /// - Returns: The output schema of your model.
    ///            Find this by browing to your model on Fal and tapping on "API" then "Schema > Output" in the left sidebar
    public func createInferenceAndPollForResult<T: Encodable & Sendable, U: Decodable & Sendable>(
        model: String,
        input: T,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> U {
        let queueResponse = try await self.createInference(
            model: model,
            input: input
        )
        guard let statusURL = queueResponse.statusURL else {
            throw FalError.missingStatusURL
        }
        let completedResponse = try await self.pollForInferenceComplete(
            statusURL: statusURL,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
        guard let responseURL = completedResponse.responseURL else {
            throw FalError.missingResultURL
        }
        return try await self.getResponse(url: responseURL)
    }

    /// Polls for the completion of a model inference, where the polling URL is Fal's
    /// `status_url` described here: https://fal.ai/docs/model-endpoints/queue
    ///
    /// - Parameters:
    ///   - statusURL: The status URL returned from the `createInference` method
    ///   - pollAttempts: The number of times to poll before `FalError.reachedRetryLimit` is raised
    ///   - secondsBetweenPollAttempts: The number of seconds between polls
    ///
    /// - Returns: A queue response with the status of `.completed`
    public func pollForInferenceComplete(
        statusURL: URL,
        pollAttempts: Int = 60,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> FalQueueResponseBody {
        try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response: FalQueueResponseBody = try await self.getResponse(
                url: statusURL
            )
            switch response.status {
            case .inQueue, .inProgress, .none:
                try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
            case .completed:
                return response
            }
        }
        throw FalError.reachedRetryLimit
    }

    /// Uploads a zip file to Fal for use in training Flux fine-tunes.
    /// See https://fal.ai/models/fal-ai/flux-lora-fast-training/api#files-upload
    ///
    /// - Parameters:
    ///
    ///   - zipData: The binary contents of your zip file. If you've added your zip file to xcassets, you
    ///              can access the file's data with `NSDataAsset(name: "myfile").data`
    ///
    ///   - name: The name of the zip file, e.g. `myfile.zip`
    ///
    /// - Returns: The URL for where your zip file lives on Fal's short term storage.
    ///            You can pass this URL to training jobs.
    public func uploadTrainingZipFile(
        zipData: Data,
        name: String
    ) async throws -> URL {
        try await uploadFile(fileData: zipData, name: name, contentType: "application/zip")
    }
}
