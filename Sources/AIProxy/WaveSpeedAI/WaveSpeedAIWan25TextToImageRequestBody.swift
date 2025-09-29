//
//  WaveSpeedAIWan25TextToImageRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

import Foundation

public struct WaveSpeedAIWan25TextToImageRequestBody: Encodable {
    public let prompt: String
    public let enablePromptExpansion: Bool?
    public let negativePrompt: String?
    public let seed: Int?
    public let size: String? // e.g. 1024*1322

    private enum CodingKeys: String, CodingKey {
        case prompt
        case enablePromptExpansion = "enable_prompt_expansion"
        case negativePrompt = "negative_prompt"
        case seed
        case size
    }

    public init(
        prompt: String,
        enablePromptExpansion: Bool? = nil,
        negativePrompt: String? = nil,
        seed: Int? = nil,
        size: String? = nil
    ) {
        self.prompt = prompt
        self.enablePromptExpansion = enablePromptExpansion
        self.negativePrompt = negativePrompt
        self.seed = seed
        self.size = size
    }
}
