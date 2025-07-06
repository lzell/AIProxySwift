//
//  OpenAIVectorStore.swift
//  AIProxy
//
//  Created by Lou Zell on 7/6/25.
//

import Foundation

/// https://platform.openai.com/docs/api-reference/vector-stores/object
public struct OpenAIVectorStore: Decodable {
    /// The Unix timestamp (in seconds) for when the vector store was created.
    public let createdAt: Int?

    /// The expiration policy for a vector store.
    public let expiresAfter: OpenAIVectorStoreExpiresAfter?

    /// The Unix timestamp (in seconds) for when the vector store will expire.
    public let expiresAt: Int?

    /// Counts of files in various states.
    public let fileCounts: FileCounts?

    /// The identifier, which can be referenced in API endpoints.
    public let id: String

    /// The Unix timestamp (in seconds) for when the vector store was last active.
    public let lastActiveAt: Int?

    /// Set of 16 key-value pairs that can be attached to an object.
    /// This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.
    /// Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters.
    public let metadata: [String: String]?

    /// The name of the vector store.
    public let name: String?

    /// The status of the vector store, which can be either `.expired`, `.inProgress`, or `.completed`.
    /// A status of `.completed` indicates that the vector store is ready for use.
    public let status: Status?

    /// The total number of bytes used by the files in the vector store.
    public let usageBytes: Int?

    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case expiresAfter = "expires_after"
        case expiresAt = "expires_at"
        case fileCounts = "file_counts"
        case id
        case lastActiveAt = "last_active_at"
        case metadata
        case name
        case status
        case usageBytes = "usage_bytes"
    }
}

extension OpenAIVectorStore {
    public struct FileCounts: Decodable {
        /// The number of files that were cancelled.
        public let cancelled: Int?

        /// The number of files that have been successfully processed.
        public let completed: Int?

        /// The number of files that have failed to process.
        public let failed: Int?

        /// The number of files that are currently being processed.
        public let inProgress: Int?

        /// The total number of files.
        public let total: Int?

        private enum CodingKeys: String, CodingKey {
            case cancelled
            case completed
            case failed
            case inProgress = "in_progress"
            case total
        }
    }

    public enum Status: String, Decodable {
        case completed
        case expired
        case inProgress = "in_progress"
    }
}
