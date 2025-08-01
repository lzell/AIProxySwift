//
//  EachAIImagenInput.swift
//  AIProxy
//
//  Created by Lou Zell on 8/1/25.
//

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
