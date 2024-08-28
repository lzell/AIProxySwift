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

    public func createFluxSchnellImage(
        input: ReplicateFluxSchnellInputSchema,
        pollAttempts: Int = 30
    ) async throws -> ReplicateFluxSchnellOutputSchema {
        let predictionResponse = try await self.createPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateFluxSchnellOutputSchema>.self
        )
        return try await self.pollLoopUntilOutputIsAvailable(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
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
    ) async throws -> ReplicateSDXLOutputSchema {
        let predictionResponse = try await self.createPrediction(
            version: version,
            input: input,
            output: ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>.self
        )
        return try await self.pollLoopUntilOutputIsAvailable(
            predictionResponse: predictionResponse,
            pollAttempts: pollAttempts
        )
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
        var request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/models/\(modelOwner)/\(modelName)/predictions",
            body: body,
            verb: .post
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, httpResponse) = try await ReplicateNetworker.send(request: request)

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
        var request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: body,
            verb: .post
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, httpResponse) = try await ReplicateNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try JSONDecoder().decode(output, from: data)
    }

    /// Polls for the result of a prediction request
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
    public func pollForPredictionResult<U: Decodable>(
        url: URL,
        numTries: Int
    ) async throws -> ReplicatePredictionResponseBody<U> {
        for _ in 0..<numTries {
            let response = try await getPredictionResult(
                url: url,
                output: ReplicatePredictionResponseBody<U>.self
            )
            if response.status == .succeeded {
                return response
            }
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        throw ReplicateError.reachedRetryLimit
    }

    /// Queries for a prediction result a single time
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
        let (data, httpResponse) = try await ReplicateNetworker.send(request: request)
        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
        return try JSONDecoder().decode(output, from: data)
    }

    private func pollLoopUntilOutputIsAvailable<T>(
        predictionResponse: ReplicatePredictionResponseBody<T>,
        pollAttempts: Int
    ) async throws -> T {
        guard let pollURL = predictionResponse.urls?.get else {
            throw ReplicateError.predictionDidNotIncludeURL
        }
        let pollResult: ReplicatePredictionResponseBody<T> = try await self.pollForPredictionResult(
            url: pollURL,
            numTries: pollAttempts
        )
        guard let output = pollResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
    }
}
