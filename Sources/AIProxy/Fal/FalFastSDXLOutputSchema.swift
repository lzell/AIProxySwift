//
//  FalFastSDXLOutputSchema.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

nonisolated public struct FalFastSDXLOutputSchema: Decodable, Sendable {
    public let hasNSFWConcepts: [Bool]?
    public let images: [FalOutputImage]?
    public let prompt: String?
    public let seed: UInt64?
    public let timings: FalTimings?
    
    public init(hasNSFWConcepts: [Bool]?, images: [FalOutputImage]?, prompt: String?, seed: UInt64?, timings: FalTimings?) {
        self.hasNSFWConcepts = hasNSFWConcepts
        self.images = images
        self.prompt = prompt
        self.seed = seed
        self.timings = timings
    }

    private enum CodingKeys: String, CodingKey {
        case hasNSFWConcepts = "has_nsfw_concepts"
        case images
        case prompt
        case seed
        case timings
    }
}
