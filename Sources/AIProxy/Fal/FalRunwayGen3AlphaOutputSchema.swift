//
//  FalRunwayGen3AlphaOutputSchema.swift
//
//
//  Created by Todd Hamilton on 10/4/24.
//

import Foundation

public struct FalRunwayGen3AlphaOutputSchema: Decodable {
    public let video: Video?

    private enum CodingKeys: String, CodingKey {
        case video
    }
}

extension FalRunwayGen3AlphaOutputSchema {
    public struct Video: Decodable {
        public let url: URL?                // The URL where the file can be downloaded from.
        public let contentType: String?     // The mime type of the file.
        public let fileName: String?        // The name of the file. It will be auto-generated if not provided.
        public let fileSize: Int?           // The size of the file in bytes.
        public let fileData: String?           // File data

        private enum CodingKeys: String, CodingKey {
            case url
            case contentType = "content_type"
            case fileName
            case fileSize
            case fileData
        }
    }
}