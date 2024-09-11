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

    static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: data)
    }

    static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
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
