//
//  FalFluxProKontextOutputSchema.swift
//
//  Created by AIProxySwiftBot.
//

import Foundation

/// Output schema for `fal-ai/flux-pro/kontext`.
public struct FalFluxProKontextOutputSchema: Decodable {
    public let images: [FalOutputImage]?
    public let prompt: String?

    public init(images: [FalOutputImage]?, prompt: String?) {
        self.images = images
        self.prompt = prompt
    }

    private enum CodingKeys: String, CodingKey {
        case images
        case prompt
    }
}

