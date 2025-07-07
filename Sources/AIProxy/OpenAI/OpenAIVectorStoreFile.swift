//
//  OpenAIVectorStoreFile.swift
//  AIProxy
//
//  Created by Lou Zell on 7/7/25.
//

/// https://platform.openai.com/docs/api-reference/vector-stores-files/file-object
public struct OpenAIVectorStoreFile: Decodable {
    /// Set of 16 key-value pairs that can be attached to an object.
    /// This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.
    /// Keys are strings with a maximum length of 64 characters.
    /// Values are strings with a maximum length of 512 characters, booleans, or numbers.
    public let attributes: [String: String]?

    /// The strategy used to chunk the file.
    public let chunkingStrategy: OpenAIVectorStoreChunkingStrategy?

    /// The Unix timestamp (in seconds) for when the vector store file was created.
    public let createdAt: Int?

    /// The identifier, which can be referenced in API endpoints.
    public let id: String?

    /// The last error associated with this vector store file. Will be nil if there are no errors.
    public let lastError: LastError?

    /// The status of the vector store file, which can be either `in_progress`, `completed`, `cancelled`, or `failed`.
    /// The status completed indicates that the vector store file is ready for use.
    public let status: Status?

    /// The total vector store usage in bytes. Note that this may be different from the original file size.
    public let usageBytes: Int?

    /// The ID of the vector store this file is attached to.
    public let vectorStoreId: String?

    private enum CodingKeys: String, CodingKey {
        case attributes
        case chunkingStrategy = "chunking_strategy"
        case createdAt = "created_at"
        case id
        case lastError = "last_error"
        case status
        case usageBytes = "usage_bytes"
        case vectorStoreId = "vector_store_id"
    }
}

extension OpenAIVectorStoreFile {
    public struct LastError: Decodable {
        /// One of `server_error` or `rate_limit_exceeded`.
        let code: Code?

        /// A human-readable description of the error.
        let message: String?
    }

    public enum Status: String, Decodable {
        case inProgress = "in_progress"
        case completed
        case cancelled
        case failed
    }
}

extension OpenAIVectorStoreFile.LastError {
    public enum Code: String, Decodable {
        case serverError = "server_error"
        case rateLimitExceeded = "rate_limit_exceeded"
    }
}
