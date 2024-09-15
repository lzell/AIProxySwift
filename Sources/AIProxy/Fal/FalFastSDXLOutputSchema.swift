//
//  FalFastSDXLOutputSchema.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

public struct FalFastSDXLOutputSchema: Decodable {
    public let hasNSFWConcepts: [Bool]?
    public let images: [Image]?
    public let prompt: String?
    public let seed: UInt64?
    public let timings: Timings?

    private enum CodingKeys: String, CodingKey {
        case hasNSFWConcepts = "has_nsfw_concepts"
        case images
        case prompt
        case seed
        case timings
    }
}

extension FalFastSDXLOutputSchema {
    public struct Image: Decodable {
        public let contentType: String?
        public let height: Int?
        public let url: URL?
        public let width: Int?

        private enum CodingKeys: String, CodingKey {
            case contentType = "content_type"
            case height
            case url
            case width
        }
    }
}

extension FalFastSDXLOutputSchema {
    public struct Timings: Decodable {
        public let inference: Double?

        private enum CodingKeys: String, CodingKey {
            case inference
        }
    }
}
