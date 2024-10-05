//
//  FalRunwayGen3AlphaInputSchema.swift
//
//
//  Created by Todd Hamilton on 10/4/24.
//

import Foundation

/// Input schema for Runway Gen3 Alpha image-to-video model
/// Docstrings from:
/// https://fal.ai/models/fal-ai/runway-gen3/turbo/image-to-video/api
public struct FalRunwayGen3AlphaInputSchema: Encodable {
    // Required

    /// The URL of the input image to be transformed into a video
    public let imageUrl: String

    /// The prompt to use for generating the video
    public let prompt: String

    // Optional

    /// The duration of the generated video
    public let duration: String?

    private enum CodingKeys: String, CodingKey {
        case prompt
        case imageUrl = "image_url"
        case duration
    }

    public init(
        imageUrl: String,
        prompt: String,
        duration: String? = nil
    ) {
        self.imageUrl = imageUrl
        self.prompt = prompt
        self.duration = duration
    }
}