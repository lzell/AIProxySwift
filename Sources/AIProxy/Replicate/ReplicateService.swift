//
//  ReplicateService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

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
    ///   - modelOwner: The owner of the model
    ///
    ///   - modelName: The name of the model
    ///
    ///   - input: The input schema, for example `ReplicateFluxSchnellInputSchema`
    ///
    /// - Returns: The inference results wrapped in ReplicateSynchronousAPIOutput
    func createSynchronousPredictionUsingOfficialModel<T: Encodable, U: Encodable>(
        modelOwner: String,
        modelName: String,
        input: T,
        secondsToWait: Int
    )  async throws -> ReplicateSynchronousAPIOutput<U>

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
    func createSynchronousPredictionUsingVersion<T: Encodable, U: Encodable>(
        modelVersion: String,
        input: T,
        secondsToWait: Int
    )  async throws -> ReplicateSynchronousAPIOutput<U>


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
        Use the following method as a replacement:
          - ReplicateService.createFluxschnellImageURLs(input:secondsToWait:)
        """)
    func createFluxSchnellImage(
        input: ReplicateFluxSchnellInputSchema,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> [URL]

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
    func createFluxSchnellImageURLs(
        input: ReplicateFluxSchnellInputSchema,
        secondsToWait: Int? = nil
    ) async throws -> [URL]

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
        Use the following method as a replacement:
          - ReplicateService.createFluxProImageURL(input:secondsToWait:)
        """)
    func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> URL

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
    func createFluxProImageURL(
        input: ReplicateFluxProInputSchema,
        secondsToWait: Int
    ) async throws -> URL

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
    func createFluxProImage_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> URL

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
    func createFluxProImageURL_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        secondsToWait: Int
    ) async throws -> URL

    /// Convenience method for creating image URL through Black Forest Lab's Flux-Pro model.
    /// https://replicate.com/black-forest-labs/flux-1.1-pro-ultra
    ///
    /// - Parameters:
    ///
    ///   - input: The input specification of the images you'd like to generate. See `ReplicateFluxProInputSchema_v1_1.swift`
    ///
    ///   - secondsToWait: Seconds to wait before failing
    ///
    /// - Returns: The URL of the generated image
    func createFluxProUltraImageURL_v1_1(
        input: ReplicateFluxProUltraInputSchema_v1_1,
        secondsToWait: Int
    ) async throws -> URL

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
    Use the following method as a replacement:
      - ReplicateService.createFluxDevImageURLs(input:secondsToWait:)
    """)
    func createFluxDevImage(
        input: ReplicateFluxDevInputSchema,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> [URL]

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
    func createFluxDevImageURLs(
        input: ReplicateFluxDevInputSchema,
        secondsToWait: Int
    ) async throws -> [URL]

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
    func createFluxPulidImage(
        input: ReplicateFluxPulidInputSchema,
        version: String,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> [URL]

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
    @available(*, deprecated, message: """
    Use the following method as a replacement:
      - ReplicateService.createSDXLImageURLs(input:secondsToWait:)
    """)
    func createSDXLImage(
        input: ReplicateSDXLInputSchema,
        version: String,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> [URL]

    /// Convenience method for creating an image through StabilityAI's SDXL model.
    /// https://replicate.com/stability-ai/sdxl
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLInputSchema.swift
    ///   - secondsToWait: The number of seconds to wait before raising `unsuccessfulRequest`
    /// - Returns: An array of image URLs
    func createSDXLImageURLs(
        input: ReplicateSDXLInputSchema,
        version: String,
        secondsToWait: Int
    ) async throws -> [URL]

    /// Convenience method for creating an image through fofr's fresh ink SDXL model
    /// https://replicate.com/fofr/sdxl-fresh-ink
    ///
    /// It's recommended to use a negative prompt with this model, for example:
    ///
    ///     let input = ReplicateSDXLFreshInkInputSchema(
    ///         prompt: "A fresh ink TOK tattoo of monument valley, Utah",
    ///         negativePrompt: "ugly, broken, distorted"
    ///     )
    ///     let urls = try await replicateService.createSDXLFreshInkImageURLs(
    ///         input: input
    ///     )
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLFreshInkInputSchema.swift
    ///   - secondsToWait: The number of seconds to wait before raising `unsuccessfulRequest`
    /// - Returns: An array of image URLs
    func createSDXLFreshInkImageURLs(
        input: ReplicateSDXLFreshInkInputSchema,
        version: String,
        secondsToWait: Int
    ) async throws -> [URL]

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
    func createFluxDevControlNetImage(
        input: ReplicateFluxDevControlNetInputSchema,
        version: String,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> [URL]

    /// Adds a new or private model to your replicate account.
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
    ///                  Visibility: models can be discovered and used by anyone. Private models can only be seen
    ///                  by the user or organization that owns them.
    ///
    ///                  Cost: When running models, you only pay for the time it takes to process your request.
    ///                  When running private models, you also pay for setup and idle time. Take a look at how billing
    ///                  works on Replicate for a full explanation.: https://replicate.com/docs/billing
    ///
    /// - Returns: URL of the model
    func createModel(
        owner: String,
        name: String,
        description: String,
        hardware: String?,
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
    func createTraining<T>(
        modelOwner: String,
        modelName: String,
        versionID: String,
        body: ReplicateTrainingRequestBody<T>
    ) async throws -> ReplicateTrainingResponseBody

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
    )  async throws -> U

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
    func pollForPredictionOutput<T>(
        predictionResponse: ReplicatePredictionResponseBody<T>,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> T

    func pollForTrainingComplete(
        url: URL,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> ReplicateTrainingResponseBody

    func mapPredictionResultURLToOutput<T: Decodable>(
        _ predictionResultURL: URL?
    ) async throws -> T
}
