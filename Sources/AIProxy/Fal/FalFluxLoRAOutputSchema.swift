//
//  FalFluxLoRAOutputSchema.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

public struct FalFluxLoRAOutputSchema: Decodable {
    public let hasNSFWConcepts: [Bool]?
    public let images: [FalOutputImage]?
    public let prompt: String?
    public let seed: UInt64?
    public let timings: FalTimings?

    private enum CodingKeys: String, CodingKey {
        case hasNSFWConcepts = "has_nsfw_concepts"
        case images
        case prompt
        case seed
        case timings
    }
}
