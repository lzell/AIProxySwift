//
//  MistralOCRRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 5/9/25.
//

import Foundation

/// Docstrings from: https://docs.mistral.ai/api/#tag/ocr/operation/ocr_v1_ocr_post
public struct MistralOCRRequestBody: Encodable {
    // Required

    /// Document to run OCR on
    public let document: Document

    /// The model to use, e.g. `.mistralOCRLatest`
    public let model: Model

    // Optional

    /// Max images to extract
    public let imageLimit: Int?

    /// Minimum height and width of image to extract
    public let imageMinSize: Int?

    /// Include image URLs in response
    public let includeImageBase64: Bool?

    private enum CodingKeys: String, CodingKey {
        case document
        case model

        case imageLimit = "image_limit"
        case imageMinSize = "image_min_size"
        case includeImageBase64 = "include_image_base64"
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        document: MistralOCRRequestBody.Document,
        model: MistralOCRRequestBody.Model,
        imageLimit: Int? = nil,
        imageMinSize: Int? = nil,
        includeImageBase64: Bool? = nil
    ) {
        self.document = document
        self.model = model
        self.imageLimit = imageLimit
        self.imageMinSize = imageMinSize
        self.includeImageBase64 = includeImageBase64
    }
}

extension MistralOCRRequestBody {
    public enum Model: String, Encodable {
        case mistralOCRLatest = "mistral-ocr-latest"
    }

    public enum Document: Encodable {
        case imageURLChunk(URL)

        private enum RootKey: String, CodingKey {
            case imageURL = "image_url"
            case type
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .imageURLChunk(let imageURL):
                try container.encode(imageURL, forKey: .imageURL)
                try container.encode("image_url", forKey: .type)
            }
        }
    }
}
