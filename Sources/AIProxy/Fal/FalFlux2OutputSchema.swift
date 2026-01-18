//
//  FalFlux2OutputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 12/23/25.
//

import Foundation

/// The output schema for Fal Flux 2 image generation
/// See https://fal.ai/models/fal-ai/flux-2/api
nonisolated public struct FalFlux2OutputSchema: Decodable, Sendable {
    /// The generated images
    public let images: [FalOutputImage]?

    /// Timing information for the generation process
    public let timings: FalTimings?

    /// Seed of the generated image. It will be the same value of the one passed in the
    /// input or the randomly generated that was used in case none was passed.
    public let seed: Int?

    /// Whether the generated images contain NSFW concepts
    public let hasNSFWConcepts: [Bool]?

    /// The prompt used for generating the image
    public let prompt: String?

    private enum CodingKeys: String, CodingKey {
        case images
        case timings
        case seed
        case hasNSFWConcepts = "has_nsfw_concepts"
        case prompt
    }
}
