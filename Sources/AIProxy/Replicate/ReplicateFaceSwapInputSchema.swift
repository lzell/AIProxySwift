//
//  ReplicateFaceSwapInputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 1/1/25.
//

import Foundation

/// Input schema for face swapping requests
public struct ReplicateFaceSwapInputSchema: Encodable {
    /// Number of days to cache results
    public let cacheDays: Int?

    /// Detection threshold
    public let detThresh: Float?

    /// Local source image URL
    public let localSource: URL?

    /// Local target image URL
    public let localTarget: URL?

    /// Request identifier
    public let requestId: String?

    /// Source image URL
    public let sourceImage: URL?

    /// Target image string
    public let targetImage: String?

    /// Weight parameter for blending (0.0-1.0)
    public let weight: Float?

    private enum CodingKeys: String, CodingKey {
        case cacheDays = "cache_days"
        case detThresh = "det_thresh"
        case localSource = "local_source"
        case localTarget = "local_target"
        case requestId = "request_id"
        case sourceImage = "source_image"
        case targetImage = "target_image"
        case weight
    }

    public init(
        cacheDays: Int? = 10,
        detThresh: Float? = 0.1,
        localSource: URL? = nil,
        localTarget: URL? = nil,
        requestId: String? = nil,
        sourceImage: URL? = nil,
        targetImage: String? = nil,
        weight: Float? = 0.5
    ) {
        self.cacheDays = cacheDays
        self.detThresh = detThresh
        self.localSource = localSource
        self.localTarget = localTarget
        self.requestId = requestId
        self.sourceImage = sourceImage
        self.targetImage = targetImage
        self.weight = weight
    }
}
