//
//  FalService+Convenience.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

extension FalService {
    /// Convenience method for creating a `fal-ai/flux/schnell` image.
    ///
    /// - Parameter input: The input schema. See `FalFluxSchnellInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the image generation.
    ///
    /// - Returns: The inference result. The `images` property of the returned value contains a list of
    ///            generated images. Each image has a `url` that you can use to fetch the image contents
    ///            (or use with AsyncImage)
    public func createFluxSchnellImage(
        input: FalFluxSchnellInputSchema
    ) async throws -> FalFluxSchnellOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/flux/schnell",
            input: input,
            pollAttempts: 60,
            secondsBetweenPollAttempts: 2
        )
    }
    
    /// Convenience method for creating a `fal-ai/fast-sdxl` image.
    ///
    /// - Parameter input: The input schema. See `FalFastSDXLInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the image generation.
    ///
    /// - Returns: The inference result. The `images` property of the returned value contains a list of
    ///            generated images. Each image has a `url` that you can use to fetch the image contents
    ///            (or use with AsyncImage)
    public func createFastSDXLImage(
        input: FalFastSDXLInputSchema
    ) async throws -> FalFastSDXLOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/fast-sdxl",
            input: input,
            pollAttempts: 60,
            secondsBetweenPollAttempts: 2
        )
    }

    /// Convenience method for training using `fal-ai/flux-lora-fast-training`
    ///
    /// - Parameter input: The input schema. See `FalFluxLoraFastTrainingInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the training.
    ///
    /// - Returns: The training result
    public func createFluxLoRAFastTraining(
        input: FalFluxLoRAFastTrainingInputSchema
    ) async throws -> FalFluxLoRAFastTrainingOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/flux-lora-fast-training",
            input: input,
            pollAttempts: 30,
            secondsBetweenPollAttempts: 10
        )
    }

    /// Convenience method for running inference on your trained Flux LoRA
    ///
    /// - Parameter input: The input schema. See `FalFluxLoraInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the inference.
    ///
    /// - Returns: The inference output with URLs to all generated images
    public func createFluxLoRAImage(
        input: FalFluxLoRAInputSchema
    ) async throws -> FalFluxLoRAOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/flux-lora",
            input: input,
            pollAttempts: 60,
            secondsBetweenPollAttempts: 2
        )
    }

    /// Convenience method for creating a `fashn/tryon` image.
    ///
    /// - Parameter input: The input schema. See `FalTryonInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the image generation.
    ///
    /// - Returns: The inference result. The `images` property of the returned value contains a list of
    ///            generated images. Each image has a `url` that you can use to fetch the image contents
    ///            (or use with AsyncImage)
    public func createTryonImage(
        input: FalTryonInputSchema
    ) async throws -> FalTryonOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/fashn/tryon/v1.5",
            input: input,
            pollAttempts: 60,
            secondsBetweenPollAttempts: 2
        )
    }

    /// Convenience method for creating a `fal-ai/flux-pro/kontext` image.
    ///
    /// - Parameter input: The input schema. See `FalFluxProKontextInputSchema.swift` for the range of controls that you
    ///                    can use to adjust the image generation.
    ///
    /// - Returns: The inference result. The `images` property of the returned value contains a list of
    ///            generated images. Each image has a `url` that you can use to fetch the image contents
    ///            (or use with AsyncImage)
    public func createFluxProKontextImage(
        input: FalFluxProKontextInputSchema,
        secondsToWait: UInt
    ) async throws -> FalFluxProKontextOutputSchema {
        return try await self.createInferenceAndPollForResult(
            model: "fal-ai/flux-pro/kontext",
            input: input,
            pollAttempts: Int(ceil(Double(secondsToWait) / 2)),
            secondsBetweenPollAttempts: 2
        )
    }

#if false
    /// Convenience method for creating a `fal-ai/runway-gen3/turbo/image-to-video` video.
    ///
    /// Select `pollAttempts` and `secondsBetweenPollAttempts` such that the multiplication of their values is the
    /// total amount of time you want to wait for the generation to complete. For example, the default values are 60 and 10,
    /// meaning by default this method will wait 600 seconds, or ten minutes, before raising `FalError.reachedRetryLimit`
    ///
    /// - Parameters:
    ///   - input: The input schema. See `FalRunwayGen3AlphaInputSchema.swift` for the controls that you
    ///                    can use to adjust the video generation.
    ///   - pollAttempts: The number of times to poll before `FalError.reachedRetryLimit` is raised
    ///   - secondsBetweenPollAttempts: The number of seconds between polls
    ///
    /// - Returns: The inference result. The `video` property of the returned value has a `url` that you can use to fetch the video contents.
    public func createRunwayGen3AlphaVideo(
        input: FalRunwayGen3AlphaInputSchema,
        pollAttempts: Int = 60,
        secondsBetweenPollAttempts: UInt64 = 10
    ) async throws -> FalRunwayGen3AlphaOutputSchema {
        let queueResponse = try await self.createInference(
            model: "fal-ai/runway-gen3/turbo/image-to-video",
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
#endif
}
