//
//  FalTryonOutputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 12/31/24.
//

import Foundation

/// Docstrings from https://fal.ai/models/fashn/tryon/api#schema-output
nonisolated public struct FalTryonOutputSchema: Decodable, Sendable {
    public let images: [TryonImage]
    
    public init(images: [TryonImage]) {
        self.images = images
    }
}

// MARK: - OutputSchema.TryonImage
extension FalTryonOutputSchema {
    nonisolated public struct TryonImage: Decodable, Sendable {
        /// The mime type of the file.
        public let contentType: String?

        /// File data.
        public let fileData: String?

        /// The name of the file. It will be auto-generated if not provided.
        public let fileName: String?

        /// The size of the file in bytes.
        public let fileSize: Int?

        /// The height of the image in pixels.
        public let height: Int?

        /// The URL where the file can be downloaded from.
        public let url: URL

        /// The width of the image in pixels.
        public let width: Int?
        
        public init(contentType: String?, fileData: String?, fileName: String?, fileSize: Int?, height: Int?, url: URL, width: Int?) {
            self.contentType = contentType
            self.fileData = fileData
            self.fileName = fileName
            self.fileSize = fileSize
            self.height = height
            self.url = url
            self.width = width
        }

        private enum CodingKeys: String, CodingKey {
            case contentType = "content_type"
            case fileData = "file_data"
            case fileName = "file_name"
            case fileSize = "file_size"
            case height
            case url
            case width
        }
    }
}
