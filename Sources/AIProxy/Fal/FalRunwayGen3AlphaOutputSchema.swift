//
//  FalRunwayGen3AlphaOutputSchema.swift
//
//
//  Created by Todd Hamilton on 10/4/24.
//

import Foundation

public struct FalRunwayGen3AlphaOutputSchema: Decodable {
    public let video: Video?
}

extension FalRunwayGen3AlphaOutputSchema {
    public struct Video: Decodable {

        /// The mime type of the file.
        public let contentType: String?

        // File data
        public let fileData: String?

        /// The name of the file. It will be auto-generated if not provided.
        public let fileName: String?

        /// The size of the file in bytes.
        public let fileSize: Int?

        /// The URL where the file can be downloaded from.
        public let url: URL?

        private enum CodingKeys: String, CodingKey {
            case contentType = "content_type"
            case fileData = "file_data"
            case fileName = "file_name"
            case fileSize = "file_size"
            case url
        }
    }
}