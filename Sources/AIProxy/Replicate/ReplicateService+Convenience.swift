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
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxSchnellInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createFluxSchnellImages(
        input: ReplicateFluxSchnellInputSchema,
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-schnell",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux-Pro model:
    /// https://replicate.com/black-forest-labs/flux-pro
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxProInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URL of the generated Flux Pro image
    public func createFluxProImage(
        input: ReplicateFluxProInputSchema,
        secondsToWait: UInt
    ) async throws -> URL {
        let prediction: ReplicatePrediction<URL> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux-Pro v1.1 model:
    /// https://replicate.com/black-forest-labs/flux-1.1-pro
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate.
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URL of the generated Flux 1.1 Pro image
    public func createFluxProImage_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        secondsToWait: UInt
    ) async throws -> URL {
        let prediction: ReplicatePrediction<URL> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-1.1-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating image URL through Black Forest Lab's Flux-Pro Ultra model.
    /// https://replicate.com/black-forest-labs/flux-1.1-pro-ultra
    ///
    /// - Parameters:
    ///   - input: The input specification of the images you'd like to generate. See `ReplicateFluxProUltraInputSchema_v1_1.swift`
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URL of the generated image
    public func createFluxProUltraImage_v1_1(
        input: ReplicateFluxProUltraInputSchema_v1_1,
        secondsToWait: UInt
    ) async throws -> URL {
        let prediction: ReplicatePrediction<URL> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-1.1-pro-ultra",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux Kontext Max model:
    /// https://replicate.com/black-forest-labs/flux-kontext-max
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxKontextInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URL of the generated Flux Kontext Max image
    public func createFluxKontextMaxImage(
        input: ReplicateFluxKontextInputSchema,
        secondsToWait: UInt
    ) async throws -> URL {
        let prediction: ReplicatePrediction<URL> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-kontext-max",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image through Black Forest Lab's Flux Kontext Pro model:
    /// https://replicate.com/black-forest-labs/flux-kontext-pro
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxKontextInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URL of the generated Flux Kontext Pro image
    public func createFluxKontextProImage(
        input: ReplicateFluxKontextInputSchema,
        secondsToWait: UInt
    ) async throws -> URL {
        let prediction: ReplicatePrediction<URL> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-kontext-pro",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating image URLs through Black Forest Lab's Flux-Dev model.
    /// https://replicate.com/black-forest-labs/flux-dev
    ///
    /// - Parameters:
    ///   - input: The input specification of the images you'd like to generate. See ReplicateFluxDevInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createFluxDevImages(
        input: ReplicateFluxDevInputSchema,
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runOfficialModel(
            modelOwner: "black-forest-labs",
            modelName: "flux-dev",
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image using https://replicate.com/zsxkib/flux-pulid
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxPuLIDInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createFluxPuLIDImages(
        version: String = "8baa7ef2255075b46f4d91cd238c21d31181b3e6a864463f967960bb0112525b",
        input: ReplicateFluxPulidInputSchema,
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runCommunityModel(
            version: version,
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image through StabilityAI's SDXL model.
    /// https://replicate.com/stability-ai/sdxl
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createSDXLImages(
        input: ReplicateSDXLInputSchema,
        version: String = "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runCommunityModel(
            version: version,
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
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
    ///     let urls = try await replicateService.createSDXLFreshInkImages(
    ///         input: input
    ///     )
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateSDXLFreshInkInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createSDXLFreshInkImages(
        input: ReplicateSDXLFreshInkInputSchema,
        version: String = "8515c238222fa529763ec99b4ba1fa9d32ab5d6ebc82b4281de99e4dbdcec943",
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runCommunityModel(
            version: version,
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for creating an image using Flux-Dev ControlNet:
    /// https://replicate.com/xlabs-ai/flux-dev-controlnet
    ///
    /// In my testing:
    /// - if the replicate model is cold, generation takes between 3 and 4 minutes
    /// - If the model is warm, generation takes 30-50 seconds
    ///
    /// - Parameters:
    ///   - input: The input specification of the image you'd like to generate. See ReplicateFluxDevControlNetInputSchema.swift
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The URLs of the generated images. The number of urls in the result is equal to `numOutputs` of the input schema.
    public func createFluxDevControlNetImages(
        input: ReplicateFluxDevControlNetInputSchema,
        version: String = "f2c31c31d81278a91b2447a304dae654c64a5d5a70340fba811bb1cbd41019a2",
        secondsToWait: UInt
    ) async throws -> [URL] {
        let prediction: ReplicatePrediction<[URL]> = try await self.runCommunityModel(
            version: version,
            input: input,
            secondsToWait: secondsToWait
        )
        return try await self.getPredictionOutput(prediction)
    }

    /// Convenience method for running the DeepSeek 7B vision model:
    /// https://replicate.com/deepseek-ai/deepseek-vl-7b-base
    ///
    /// In my testing, vision requests were completing in less than 2 seconds once the model was warm.
    /// Note that the result can take several minutes if the model is cold.
    ///
    /// - Parameters:
    ///   - input: The input containing the image and prompt that you want to have DeepSeek VL inspect
    ///   - secondsToWait: Seconds to wait before raising a timeout error
    ///
    /// - Returns: The generated content
    public func runDeepSeekVL7B(
        input: ReplicateDeepSeekVL7BInputSchema,
        version: String = "d1823e6f68cd3d57f2d315b9357dfa85f53817120ae0de8d2b95fbc8e93a1385",
        secondsToWait: UInt
    ) async throws -> String {
        let prediction: ReplicatePrediction<[String]> = try await self.runCommunityModel(
            version: version,
            input: input,
            secondsToWait: secondsToWait
        )
        return (try await self.getPredictionOutput(prediction)).joined(separator: "")
    }

    // MARK: - Deprecated
    @available(*, deprecated, message: "Please use createFluxSchnellImages")
    public func createFluxSchnellImageURLs(
        input: ReplicateFluxSchnellInputSchema,
        secondsToWait: UInt
    ) async throws -> [URL] {
        return try await self.createFluxSchnellImages(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxProImage")
    public func createFluxProImageURLs(
        input: ReplicateFluxProInputSchema,
        secondsToWait: UInt
    ) async throws -> URL {
        return try await self.createFluxProImage(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxProImage")
    public func createFluxProImageURL(
        input: ReplicateFluxProInputSchema,
        secondsToWait: UInt
    ) async throws -> URL {
        return try await self.createFluxProImage(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxProImage_v1_1")
    public func createFluxProImageURL_v1_1(
        input: ReplicateFluxProInputSchema_v1_1,
        secondsToWait: UInt
    ) async throws -> URL {
        return try await self.createFluxProImage_v1_1(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxProUltraImage_v1_1")
    public func createFluxProUltraImageURL_v1_1(
        input: ReplicateFluxProUltraInputSchema_v1_1,
        secondsToWait: UInt
    ) async throws -> URL {
        return try await self.createFluxProUltraImage_v1_1(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxDevImages")
    public func createFluxDevImageURLs(
        input: ReplicateFluxDevInputSchema,
        secondsToWait: UInt
    ) async throws -> [URL] {
        return try await self.createFluxDevImages(input: input, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createFluxPuLIDImages")
    public func createFluxPulidImage(
        input: ReplicateFluxPulidInputSchema,
        version: String = "8baa7ef2255075b46f4d91cd238c21d31181b3e6a864463f967960bb0112525b",
        pollAttempts: Int = 30,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> [URL] {
        return try await self.createFluxPuLIDImages(
            version: version,
            input: input,
            secondsToWait: UInt(pollAttempts) * UInt(secondsBetweenPollAttempts)
        )
    }

    @available(*, deprecated, message: "Please use createSDXLImages")
    public func createSDXLImageURLs(
        input: ReplicateSDXLInputSchema,
        version: String = "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
        secondsToWait: UInt
    ) async throws -> [URL] {
        return try await self.createSDXLImages(input: input, version: version, secondsToWait: secondsToWait)
    }

    @available(*, deprecated, message: "Please use createSDXLFreshInkImages")
    public func createSDXLFreshInkImageURLs(
        input: ReplicateSDXLFreshInkInputSchema,
        version: String = "8515c238222fa529763ec99b4ba1fa9d32ab5d6ebc82b4281de99e4dbdcec943",
        secondsToWait: UInt
    ) async throws -> [URL] {
        return try await self.createSDXLFreshInkImages(input: input, version: version, secondsToWait: UInt(secondsToWait))
    }

    @available(*, deprecated, message: "Please use createFluxDevControlNetImages")
    public func createFluxDevControlNetImage(
        input: ReplicateFluxDevControlNetInputSchema,
        version: String = "f2c31c31d81278a91b2447a304dae654c64a5d5a70340fba811bb1cbd41019a2",
        pollAttempts: Int = 70,
        secondsBetweenPollAttempts: UInt64 = 5
    ) async throws -> [URL] {
        return try await self.createFluxDevControlNetImages(
            input: input,
            version: version,
            secondsToWait: UInt(pollAttempts) * UInt(secondsBetweenPollAttempts)
        )
    }
}
