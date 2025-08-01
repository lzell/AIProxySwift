//
//  EachAIVeoInput.swift
//  AIProxy
//
//  Created by Lou Zell on 8/1/25.
//

import Foundation

public struct EachAIVeoInput: Encodable {
    // Required
    public let imageURL: URL
    public let prompt: String

    // Optional
    public let generateAudio: Bool?

    private enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case prompt
        case generateAudio = "generate_audio"
    }

    public init(
        imageURL: URL,
        prompt: String,
        generateAudio: Bool? = nil
    ) {
        self.imageURL = imageURL
        self.prompt = prompt
        self.generateAudio = generateAudio
    }
}
