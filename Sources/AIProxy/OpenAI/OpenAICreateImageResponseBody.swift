//
//  OpenAICreateImageResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/11/25.
//

import Foundation

/// Response body for the 'Create image' endpoint:
/// https://platform.openai.com/docs/api-reference/images/create
public struct OpenAICreateImageResponseBody: Decodable {
    /// A list of generated images returned from the 'Create Image' endpoint
    public let data: [ImageData]
}

// MARK: -
extension OpenAICreateImageResponseBody {
    /// https://platform.openai.com/docs/api-reference/images/object
    public struct ImageData: Decodable {
        /// The base64-encoded JSON of the generated image, if `responseFormat` on OpenAICreateImageRequestBody is `b64_json`.
        public let b64JSON: String?

        /// The prompt that was used to generate the image, if there was any revision to the prompt.
        public let revisedPrompt: String?

        /// The URL of the generated image,  if `responseFormat` on OpenAICreateImageRequestBody is `url` (default).
        public let url: URL?

        enum CodingKeys: String, CodingKey {
            case b64JSON = "b64_json"
            case revisedPrompt = "revised_prompt"
            case url
        }
    }
}
