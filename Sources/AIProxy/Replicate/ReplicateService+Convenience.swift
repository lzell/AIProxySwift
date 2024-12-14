//
//  ReplicateService+Convenience.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

/// Convenience methods for ReplicateService
extension ReplicateService {
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
        secondsToWait: Int = 30
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
        Use the following method as a replacement:
          - ReplicateService.createFluxProImageURL(input:secondsToWait:)
        """)
    public func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        pollAttempts: Int = 60,
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
        secondsToWait: Int = 60
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
        secondsToWait: Int = 60
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
    public func createFluxProUltraImageURL_v1_1(
        input: ReplicateFluxProUltraInputSchema_v1_1,
        secondsToWait: Int = 60
    ) async throws -> URL {
        let output: ReplicateSynchronousAPIOutput<String> = try await self.createSynchronousPredictionUsingOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-1.1-pro-ultra",
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
    Use the following method as a replacement:
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
    @available(*, deprecated, message: """
    Use the following method as a replacement:
      - ReplicateService.createSDXLImageURLs(input:secondsToWait:)
    """)
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

    /// Convenience method for creating an image through StabilityAI's SDXL model.
    /// https://replicate.com/stability-ai/sdxl
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLInputSchema.swift
    ///   - secondsToWait: The number of seconds to wait before raising `unsuccessfulRequest`
    /// - Returns: An array of image URLs
    public func createSDXLImageURLs(
        input: ReplicateSDXLInputSchema,
        version: String = "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
        secondsToWait: Int = 60
    ) async throws -> [URL] {
        let apiResult: ReplicateSynchronousAPIOutput<[URL]> = try await self.createSynchronousPredictionUsingVersion(
            modelVersion: version,
            input: input,
            secondsToWait: secondsToWait
        )
        guard let output = apiResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
    }

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
    public func createSDXLFreshInkImageURLs(
        input: ReplicateSDXLFreshInkInputSchema,
        version: String = "8515c238222fa529763ec99b4ba1fa9d32ab5d6ebc82b4281de99e4dbdcec943",
        secondsToWait: Int = 60
    ) async throws -> [URL] {
        let apiResult: ReplicateSynchronousAPIOutput<[URL]> = try await self.createSynchronousPredictionUsingVersion(
            modelVersion: version,
            input: input,
            secondsToWait: secondsToWait
        )
        guard let output = apiResult.output else {
            throw ReplicateError.predictionDidNotIncludeOutput
        }
        return output
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

}
