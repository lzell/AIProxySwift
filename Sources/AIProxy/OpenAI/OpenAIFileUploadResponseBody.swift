//
//  OpenAIFileUploadResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/27/25.
//


nonisolated public struct OpenAIFileUploadResponseBody: Decodable, Sendable {
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

    public init(bytes: Int?, createdAt: Int?, expiresAt: Int?, filename: String?, id: String, purpose: String?) {
        self.bytes = bytes
        self.createdAt = createdAt
        self.expiresAt = expiresAt
        self.filename = filename
        self.id = id
        self.purpose = purpose
    }

    private enum CodingKeys: String, CodingKey {
        case bytes
        case createdAt = "created_at"
        case expiresAt = "expires_at"
        case filename
        case id
        case purpose
    }
}
