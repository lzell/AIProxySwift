//
//  MistralOCRResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 5/9/25.
//

import Foundation

/// Docstrings from: https://docs.mistral.ai/api/#tag/ocr/operation/ocr_v1_ocr_post
public struct MistralOCRResponseBody: Decodable {
    public let model: String?
    public let pages: [Page]
    public let usageInfo: UsageInfo?
}

extension MistralOCRResponseBody {

    public struct Page: Decodable {
        public let dimensions: Dimensions?
        public let images: [ExtractedImage]?
        public let index: Int?
        public let markdown: String?
    }

    public struct UsageInfo: Decodable {
        public let docSizeBytes: Int?
        public let pagesProcessed: Int?

        private enum CodingKeys: String, CodingKey {
            case docSizeBytes = "doc_size_bytes"
            case pagesProcessed = "pages_processed"
        }
    }
}

extension MistralOCRResponseBody.Page {
    public struct ExtractedImage: Decodable {
        public let imageBase64: String?

        private enum CodingKeys: String, CodingKey {
            case imageBase64 = "image_base64"
        }
    }

    public struct Dimensions: Decodable {
        /// Dots per inch of the page-image
        public let dpi: Int?

        /// Height of the image in pixels
        public let height: Int?

        /// Width of the image in pixels
        public let width: Int?
    }
}
