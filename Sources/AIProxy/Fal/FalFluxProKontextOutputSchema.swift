//
//  FalFluxProKontextOutputSchema.swift
//
//  Created by AIProxySwiftBot.
//

import Foundation

/// Output schema for `fal-ai/flux-pro/kontext`.
/// https://fal.ai/models/fal-ai/flux-pro/kontext/api#schema-output
public struct FalFluxProKontextOutputSchema: Decodable {
    public let images: [FalOutputImage]?
    public let prompt: String?
}

