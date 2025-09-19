//
//  ReplicateFluxKontextInputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 5/31/25.
//

import Foundation

nonisolated public struct ReplicateFluxKontextInputSchema: Encodable, Sendable {
    // Required

    /// Image to use as reference. Must be a URI (jpeg, png, gif, or webp).
    public let inputImage: URL

    /// Text description of what you want to generate, or the instruction on how to edit the given image.
    public let prompt: String

    // Optional

    /// Aspect ratio of the generated image.
    /// Use `"match_input_image"` to match the aspect ratio of the input image.
    public let aspectRatio: String?

    /// Random seed for reproducible generation.
    public let seed: Int?

    private enum CodingKeys: String, CodingKey {
        case inputImage = "input_image"
        case prompt
        case aspectRatio = "aspect_ratio"
        case seed
    }

    public init(
        inputImage: URL,
        prompt: String,
        aspectRatio: String? = nil,
        seed: Int? = nil
    ) {
        self.inputImage = inputImage
        self.prompt = prompt
        self.aspectRatio = aspectRatio
        self.seed = seed
    }
}
