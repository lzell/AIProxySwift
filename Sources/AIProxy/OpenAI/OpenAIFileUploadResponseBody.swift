//
//  OpenAIFileUploadResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/27/25.
//


public struct OpenAIFileUploadResponseBody: Decodable {
    /// The size of the file, in bytes.
    public let bytes: Int?

    /// The Unix timestamp (in seconds) for when the file was created.
    public let createdAt: Int?

    /// The Unix timestamp (in seconds) for when the file will expire.
    public let expiresAt: Int?

    /// The name of the file.
    public let filename: String?

    /// The file identifier, which can be referenced in the API endpoints.
    public let id: String

    /// The intended purpose of the file.
    public let purpose: String?

    private enum CodingKeys: String, CodingKey {
        case bytes
        case createdAt = "created_at"
        case expiresAt = "expires_at"
        case filename
        case id
        case purpose
    }
}
