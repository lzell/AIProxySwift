//
//  ReplicateService.swift
//
//  Created by Lou Zell on 8/23/24.
//

import Foundation


open class ReplicateService {
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

    /// Convenience method for creating an image through Black Forest Lab's Flux-Schnell model:
    /// https://replicate.com/black-forest-labs/flux-schnell
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxSchnellInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An array of image URLs
    @available(*, deprecated, message: """
        Use one of the following methods as a replacement:
          - ReplicateService.createFluxSchnellImages(input:secondsToWait:)
          - ReplicateService.createFluxschnellImageURLs(input:secondsToWait:)
        """)
    public func createFluxSchnellImage(
        input: ReplicateFluxSchnellInputSchema,
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 1
    ) async throws -> [URL] {
        return try await self.predictAndPollUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating images through Black Forest Lab's Flux-Schnell model:
    /// https://replicate.com/black-forest-labs/flux-schnell
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxSchnellInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: An array of images as Data. The number of images in the result will be equal
    ///            to `numOutputs` that you pass in the input schema. Use the `UIImage` or
    ///            `NSImage` helpers to render the image data, e.g. `UIImage(data:)`
    public func createFluxSchnellImages(
        input: ReplicateFluxSchnellInputSchema,
        secondsToWait: Int = 10
    ) async throws -> [Data] {
        let output: ReplicateSynchronousAPIOutput<[String]> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            secondsToWait: secondsToWait
        )
        guard let imageDataAsDataURI = output.output else {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return mapBase64DataURIsToData(imageDataAsDataURI)
    }

    /// Convenience method for creating image URLs through Black Forest Lab's Flux-Schnell model.
    /// https://replicate.com/black-forest-labs/flux-schnell
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxSchnellInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: An array of URLs. The number of urls in the result will be equal to
    ///            `numOutputs` that you pass in the input schema.
    public func createFluxSchnellImageURLs(
        input: ReplicateFluxSchnellInputSchema,
        secondsToWait: Int = 10
    ) async throws -> [URL] {
        let output: ReplicateSynchronousAPIOutput<[String]> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            secondsToWait: secondsToWait
        )
        if output.output == nil {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return try await self.mapPredictionResultURLToOutput(output.predictionResultURL)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux-Pro model:
    /// https://replicate.com/black-forest-labs/flux-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxProInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An image URL
    ///
    @available(*, deprecated, message: """
        Use one of the following methods as a replacement:
          - ReplicateService.createFluxProImage(input:secondsToWait:)
          - ReplicateService.createFluxProImageURL(input:secondsToWait:)
        """)
    public func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> URL {
        return try await self.predictAndPollUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-pro",
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating images through Black Forest Lab's Flux-Pro model:
    /// https://replicate.com/black-forest-labs/flux-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxProInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: The generated image data. Use the `UIImage` or `NSImage` helpers to render
    ///            the image data, e.g. `UIImage(data:)`
    public func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        secondsToWait: Int = 30
    ) async throws -> Data {
        let output: ReplicateSynchronousAPIOutput<String> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        guard let imageDataAsDataURI = output.output else {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        guard let data = mapBase64DataURIToData(imageDataAsDataURI) else {
            throw AIProxyError.assertion("Could not map replicate dataURI to Data")
        }
        return data
    }

    /// Convenience method for creating image URL through Black Forest Lab's Flux-Pro model.
    /// https://replicate.com/black-forest-labs/flux-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxProInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: The URL of the generated image
    public func createFluxProImageURL(
        input: ReplicateFluxProInputSchema,
        secondsToWait: Int = 30
    ) async throws -> URL {
        let output: ReplicateSynchronousAPIOutput<String> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        if output.output == nil {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return try await self.mapPredictionResultURLToOutput(output.predictionResultURL)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux-Pro v1.1 model:
    /// https://replicate.com/black-forest-labs/flux-1.1-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate.
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An image URL
    @available(*, deprecated, message: """
        Use one of the following methods as a replacement:
          - ReplicateService.createFluxProImageURL_v1_1(input:secondsToWait:)
        """)
    public func createFluxProImage_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> URL {
        return try await self.predictAndPollUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-1.1-pro",
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating image URL through Black Forest Lab's Flux-Pro model.
    /// https://replicate.com/black-forest-labs/flux-1.1-pro
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See `ReplicateFluxProInputSchema_v1_1.swift`
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: The URL of the generated image
    public func createFluxProImageURL_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        secondsToWait: Int = 30
    ) async throws -> URL {
        let output: ReplicateSynchronousAPIOutput<String> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-1.1-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        if output.output == nil {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return try await self.mapPredictionResultURLToOutput(output.predictionResultURL)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux-Dev model:
    /// https://replicate.com/black-forest-labs/flux-dev
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxDevInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An array of image URLs
    @available(*, deprecated, message: """
    Use one of the following methods as a replacement:
      - ReplicateService.createFluxDevImages(input:secondsToWait:)
      - ReplicateService.createFluxDevImageURLs(input:secondsToWait:)
    """)
    public func createFluxDevImage(
        input: ReplicateFluxDevInputSchema,
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 1
    ) async throws -> [URL] {
        return try await self.predictAndPollUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-dev",
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating images through Black Forest Lab's Flux-Dev model:
    /// https://replicate.com/black-forest-labs/flux-dev
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxDevInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: An array of images as Data. The number of images in the result will be equal
    ///            to `numOutputs` that you pass in the input schema.  Use the `UIImage` or
    ///            `NSImage` helpers to render the image data, e.g. `UIImage(data:)`
    public func createFluxDevImages(
        input: ReplicateFluxDevInputSchema,
        secondsToWait: Int = 30
    ) async throws -> [Data] {
        let output: ReplicateSynchronousAPIOutput<[String]> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-dev",
            input: input,
            secondsToWait: secondsToWait
        )
        guard let imageDataAsDataURI = output.output else {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return mapBase64DataURIsToData(imageDataAsDataURI)
    }

    /// Convenience method for creating image URLs through Black Forest Lab's Flux-Dev model.
    /// https://replicate.com/black-forest-labs/flux-dev
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxDevInputSchema.swift
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: An array of URLs. The number of urls in the result will be equal to
    ///           `numOutputs` that you pass in the input schema.
    public func createFluxDevImageURLs(
        input: ReplicateFluxDevInputSchema,
        secondsToWait: Int = 10
    ) async throws -> [URL] {
        let output: ReplicateSynchronousAPIOutput<[String]> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-dev",
            input: input,
            secondsToWait: secondsToWait
        )
        if output.output == nil {
            throw ReplicateError.predictionFailed("Reached wait limit of \(secondsToWait) seconds. You can adjust this.")
        }
        return try await self.mapPredictionResultURLToOutput(output.predictionResultURL)
    }

    /// Convenience method for creating an image using https://replicate.com/zsxkib/flux-pulid
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxPuLIDInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An array of image URLs
    public func createFluxPulidImage(
        input: ReplicateFluxPulidInputSchema,
        version: String = "8baa7ef2255075b46f4d91cd238c21d31181b3e6a864463f967960bb0112525b",
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> [URL] {
        return try await self.predictAndPollUsingVersion(
            version: version,
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating an image through StabilityAI's SDXL model.
    /// https://replicate.com/stability-ai/sdxl
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An array of image URLs
    public func createSDXLImage(
        input: ReplicateSDXLInputSchema,
        version: String = "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
        pollAttempts: Int = 60,
        secondsBetweenPollAttempts: UInt64 = 1
    ) async throws -> [URL] {
        return try await self.predictAndPollUsingVersion(
            version: version,
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
    }

    /// Convenience method for creating an image using Flux-Dev ControlNet:
    /// https://replicate.com/xlabs-ai/flux-dev-controlnet
    ///
    /// In my testing:
    /// - if the replicate model is cold, generation takes between 3 and 4 minutes
    /// - If the model is warm, generation takes 30-50 seconds
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxDevControlNetInputSchema.swift
    ///
    ///   - pollAttempts: The number of attempts to poll for the resulting image. If the result
    ///   is not available within `pollAttempts`, `ReplicateError.reachedRetryLimit` is thrown.
    ///
    ///   - secondsBetweenPollAttempts: The number of seconds between poll attempts. The total
    ///   amount of time that this method will wait for a result is `pollAttempts *
    ///   secondsBetweenPollAttempts`
    ///
    /// - Returns: An array of image URLs
    public func createFluxDevControlNetImage(
        input: ReplicateFluxDevControlNetInputSchema,
        version: String = "f2c31c31d81278a91b2447a304dae654c64a5d5a70340fba811bb1cbd41019a2",
        pollAttempts: Int = 70,
        secondsBetweenPollAttempts: UInt64 = 5
    ) async throws -> [URL] {
        return try await self.predictAndPollUsingVersion(
            version: version,
            input: input,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
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
            contentType: "application/json",
            headers: ["Prefer": "wait=\(secondsToWait)"]
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try ReplicateSynchronousAPIOutput<U>.deserialize(from: data)
    }
    
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
        let encoder = JSONEncoder()
        let body = try encoder.encode(
            ReplicatePredictionRequestBody(
                input: input,
                version: modelVersion
            )
        )
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/v1/predictions",
            body: body,
            verb: .post,
            contentType: "application/json",
            headers: ["Prefer": "wait=\(secondsToWait)"]
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try ReplicateSynchronousAPIOutput<U>.deserialize(from: data)
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

    private func predictAndPollUsingVersion<T: Encodable, U: Decodable>(
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

    private func predictAndPollUsingOfficialModel<T: Encodable, U: Decodable>(
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

    public func mapPredictionResultURLToOutput<T: Decodable>(
        _ predictionResultURL: URL?
    ) async throws -> T {
        guard let predictionResultURL = predictionResultURL else {
            throw AIProxyError.assertion("Replicate prediction URL is nil")
        }
        let prediction = try await self.actorGetPredictionResult(
            url: predictionResultURL,
            output: ReplicatePredictionResponseBody<T>.self
        )
        guard let predictionOutput = prediction.output else {
            throw AIProxyError.assertion("Replicate prediction does not have any output")
        }
        return predictionOutput
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
