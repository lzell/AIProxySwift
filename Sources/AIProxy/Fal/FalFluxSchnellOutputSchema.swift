//
//  FalFluxSchnellOutputSchema.swift
//
//
//  Created by Hunor Zoltáni on 01.03.2025.
//

import Foundation

public struct FalFluxSchnellOutputSchema: Decodable {
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
