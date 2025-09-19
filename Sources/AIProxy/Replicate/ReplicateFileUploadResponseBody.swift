//
//  ReplicateFileUploadResponseBody.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import Foundation

nonisolated public struct ReplicateFileUploadResponseBody: Decodable, Sendable {
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
    
    public init(contentType: String?, checksums: Checksums?, createdAt: String?, etag: String?, expiresAt: String?, id: String?, name: String?, size: Int?, urls: ActionURLs) {
        self.contentType = contentType
        self.checksums = checksums
        self.createdAt = createdAt
        self.etag = etag
        self.expiresAt = expiresAt
        self.id = id
        self.name = name
        self.size = size
        self.urls = urls
    }
}

extension ReplicateFileUploadResponseBody {
    nonisolated public struct Checksums: Decodable, Sendable {
        public let md5: String
        public let sha256: String
        
        public init(md5: String, sha256: String) {
            self.md5 = md5
            self.sha256 = sha256
        }
    }
}

extension ReplicateFileUploadResponseBody {
    nonisolated public struct ActionURLs: Decodable, Sendable {
        public let get: URL
        
        public init(get: URL) {
            self.get = get
        }
    }
}
