//
//  EachAIRunModelRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 7/26/25.
//

import Foundation

public struct EachAICreatePredictionRequestBody<T: Encodable>: Encodable {
    public let input: T
    public let model: String
    public let version: String

    public init(
        input: T,
        model: String,
        version: String
    ) {
        self.input = input
        self.model = model
        self.version = version
    }
}

struct EachAIVeoInput: Encodable {
    public let generateAudio: Bool
    public let imageURL: URL
    public let prompt: String

    private enum CodingKeys: String, CodingKey {
        case generateAudio = "generate_audio"
        case imageURL = "image_url"
        case prompt
    }

    public init(
        generateAudio: Bool,
        imageURL: URL,
        prompt: String
    ) {
        self.generateAudio = generateAudio
        self.imageURL = imageURL
        self.prompt = prompt
    }
}

public struct EachAIImagenInput: Encodable {
    public let prompt: String

    public let aspectRatio: String?
    public let outputFormat: String?
    public let safetyFilterLevel: String?

    private enum CodingKeys: String, CodingKey {
        case prompt
        case aspectRatio = "aspect_ratio"
        case outputFormat = "output_format"
        case safetyFilterLevel = "safety_filter_level"
    }

    public init(
        prompt: String,
        aspectRatio: String? = nil,
        outputFormat: String? = nil,
        safetyFilterLevel: String? = nil
    ) {
        self.prompt = prompt
        self.aspectRatio = aspectRatio
        self.outputFormat = outputFormat
        self.safetyFilterLevel = safetyFilterLevel
    }
}
