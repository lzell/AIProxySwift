//
//  FalOutputImage.swift
//
//
//  Created by Lou Zell on 10/4/24.
//
// https://fal.ai/models/fal-ai/flux-2/api#type-ImageFile

import Foundation

nonisolated public struct FalOutputImage: Decodable, Sendable {

    /// The URL where the file can be downloaded from.
    public let url: URL?

    /// The mime type of the file.
    public let contentType: String?

    /// The name of the file. It will be auto-generated if not provided.
    public let fileName: String?

    /// The size of the file in bytes.
    public let fileSize: Int?

    /// File data
    public let fileData: String?

    /// The width of the image
    public let width: Int?

    /// The height of the image
    public let height: Int?

    private enum CodingKeys: String, CodingKey {
        case url
        case contentType = "content_type"
        case fileName = "file_name"
        case fileSize = "file_size"
        case fileData = "file_data"
        case width
        case height
    }
}
