//
//  FalService+Convenience.swift
//
//
//  Created by Lou Zell on 12/18/24.
//

import Foundation

extension FalService {
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
        let queueResponse = try await self.createInference(
            model: "fal-ai/fast-sdxl",  // Add lightning to this!
            input: input
        )
        guard let statusURL = queueResponse.statusURL else {
            throw FalError.missingStatusURL
        }
        let completedResponse = try await self.pollForInferenceComplete(
            statusURL: statusURL
        )
        guard let responseURL = completedResponse.responseURL else {
            throw FalError.missingResultURL
        }
        return try await self.getResponse(url: responseURL)
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
        let queueResponse = try await self.createInference(
            model: "fal-ai/flux-lora-fast-training",
            input: input
        )
        guard let statusURL = queueResponse.statusURL else {
            throw FalError.missingStatusURL
        }
        let completedResponse = try await self.pollForInferenceComplete(
            statusURL: statusURL,
            pollAttempts: 30,
            secondsBetweenPollAttempts: 10
        )
        guard let responseURL = completedResponse.responseURL else {
            throw FalError.missingResultURL
        }
        return try await self.getResponse(url: responseURL)
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
        let queueResponse = try await self.createInference(
            model: "fal-ai/flux-lora",
            input: input
        )
        guard let statusURL = queueResponse.statusURL else {
            throw FalError.missingStatusURL
        }
        let completedResponse = try await self.pollForInferenceComplete(
            statusURL: statusURL
        )
        guard let responseURL = completedResponse.responseURL else {
            throw FalError.missingResultURL
        }
        return try await self.getResponse(url: responseURL)
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
