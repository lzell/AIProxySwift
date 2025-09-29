//
//  WaveSpeedAIWan25ImageToVideoFastRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

import Foundation

public struct WaveSpeedAIWan25ImageToVideoFastRequestBody: Encodable {
    public let image: URL
    public let prompt: String
    public let audio: URL?
    public let duration: Duration?
    public let negativePrompt: String?
    public let resolution: Resolution?
    public let seed: Int?

    public init(
        image: URL,
        prompt: String,
        audio: URL? = nil,
        duration: WaveSpeedAIWan25ImageToVideoFastRequestBody.Duration? = nil,
        negativePrompt: String? = nil,
        resolution: WaveSpeedAIWan25ImageToVideoFastRequestBody.Resolution? = nil,
        seed: Int? = nil
    ) {
        self.image = image
        self.prompt = prompt
        self.audio = audio
        self.duration = duration
        self.negativePrompt = negativePrompt
        self.resolution = resolution
        self.seed = seed
    }

    private enum CodingKeys: String, CodingKey {
        case image
        case prompt
        case audio
        case duration
        case negativePrompt = "negative_prompt"
        case resolution
        case seed
    }
}

extension WaveSpeedAIWan25ImageToVideoFastRequestBody {
    public enum Resolution: String, Encodable {
        case res720 = "720p"
        case res1080 = "1080p"
    }

    public enum Duration: Int, Encodable {
        case fiveSeconds = 5
        case tenSeconds = 10
    }
}
