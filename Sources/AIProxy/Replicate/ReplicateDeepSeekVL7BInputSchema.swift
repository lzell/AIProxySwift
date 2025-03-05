//
//  ReplicateDeepSeekVL7BInputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 3/5/25.
//

import Foundation

/// https://replicate.com/deepseek-ai/deepseek-vl-7b-base?output=json
public struct ReplicateDeepSeekVL7BInputSchema: Encodable {
    /// Input image
    public let image: URL

    /// Input prompt
    /// Default: "Describe this image"
    public let prompt: String?

    /// Maximum number of tokens to generate
    /// Default: 512
    public let maxNewTokens: Int?

    private enum CodingKeys: String, CodingKey {
        case image
        case prompt
        case maxNewTokens = "max_new_tokens"
    }

    public init(
        image: URL,
        prompt: String? = nil,
        maxNewTokens: Int? = nil
    ) {
        self.image = image
        self.prompt = prompt
        self.maxNewTokens = maxNewTokens
    }
}
