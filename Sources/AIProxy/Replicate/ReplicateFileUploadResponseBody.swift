//
//  ReplicateFileUploadResponseBody.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import Foundation

public struct ReplicateFileUploadResponseBody: Decodable {
    public let contentType: String?
    public let checksums: Checksums?
    public let createdAt: String?
    public let etag: String?
    public let expiresAt: String?
    public let id: String?
    public let name: String?
    public let size: Int?
    public let urls: ActionURLs

    private enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case checksums
        case createdAt = "created_at"
        case etag
        case expiresAt = "expires_at"
        case id
        case name
        case size
        case urls
    }
}

extension ReplicateFileUploadResponseBody {
    public struct Checksums: Decodable {
        public let md5: String
        public let sha256: String
    }
}

extension ReplicateFileUploadResponseBody {
    public struct ActionURLs: Decodable {
        public let get: URL
    }
}
