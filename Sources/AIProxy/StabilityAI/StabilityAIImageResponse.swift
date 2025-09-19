//
//  StabilityAIUltraResponseBody.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

import Foundation

/// This type diverges a touch from the other response models in this package. Stability
/// includes pertinent information in the response header, and the response body is the image
/// binary. This type encompasses both.
///
/// See the "Response Headers" section here:
/// https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post
nonisolated public struct StabilityAIImageResponse:  Sendable {

    /// The image data
    public let imageData: Data

    /// The format of the generated image.
    ///
    /// To receive the bytes of the image directly, specify `image/*` in the accept header. To
    /// receive the bytes base64 encoded inside of a JSON payload, specify `application/json`.
    public let contentType: String?

    /// Indicates the reason the generation finished.
    ///
    ///     SUCCESS = successful generation.
    ///     CONTENT_FILTERED = successful generation, however the output violated our content
    ///                        moderation policy and has been blurred as a result.
    ///
    /// NOTE: This header is absent on JSON encoded responses because it is present in the body
    ///       as finish_reason.
    public let finishReason: String?

    /// The seed used as random noise for this generation.
    /// Example: "343940597"
    ///
    /// NOTE: This header is absent on JSON encoded responses because it is present in the body
    ///       as seed.
    public let seed: String?
    
    public init(imageData: Data, contentType: String?, finishReason: String?, seed: String?) {
        self.imageData = imageData
        self.contentType = contentType
        self.finishReason = finishReason
        self.seed = seed
    }
}
