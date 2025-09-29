//
//  WaveSpeedAICreatePredictionResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 9/29/25.
//

import Foundation

public struct WaveSpeedAICreatePredictionResponseBody: Decodable {
    public let code: Int?
    public let message: String?
    public let data: Prediction?
}

extension WaveSpeedAICreatePredictionResponseBody {
    public struct Prediction: Decodable {
        public let createdAt: String?
        public let error: String?
        public let executionTime: Double?
        public let hasNsfwContents: [String]?
        public let id: String?
        public let model: String?
        public let status: String?
        public let timings: Timings?
        public let urls: Urls?

        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case error
            case executionTime // This isn't snake_case in the API response
            case hasNsfwContents = "has_nsfw_contents"
            case id
            case model
            case status
            case timings
            case urls
        }
    }

    public struct Urls: Decodable {
        public let `get`: URL
    }

    public struct Timings: Decodable {
        public let inference: Double
    }
}
