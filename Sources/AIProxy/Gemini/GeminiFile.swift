//
//  GeminiFile.swift
//
//
//  Created by Lou Zell on 10/24/24.
//

import Foundation

nonisolated public struct GeminiFile: Decodable, Sendable {
    public let createTime: String?
    public let expirationTime: String?
    public let mimeType: String?
    public let name: String?
    public let sha256Hash: String?
    public let sizeBytes: String?
    public let state: State
    public let updateTime: String?
    public let uri: URL
    public let videoMetadata: VideoMetadata?
    
    public init(createTime: String?, expirationTime: String?, mimeType: String?, name: String?, sha256Hash: String?, sizeBytes: String?, state: State, updateTime: String?, uri: URL, videoMetadata: VideoMetadata?) {
        self.createTime = createTime
        self.expirationTime = expirationTime
        self.mimeType = mimeType
        self.name = name
        self.sha256Hash = sha256Hash
        self.sizeBytes = sizeBytes
        self.state = state
        self.updateTime = updateTime
        self.uri = uri
        self.videoMetadata = videoMetadata
    }
}

// MARK: - GeminiFile.State
extension GeminiFile {
    nonisolated public enum State: String, Decodable, Sendable {
        case processing = "PROCESSING"
        case active = "ACTIVE"
    }
}

// MARK: - GeminiFile.VideoMetadata
extension GeminiFile {
    nonisolated public struct VideoMetadata: Decodable, Sendable {
        public let videoDuration: String
        
        public init(videoDuration: String) {
            self.videoDuration = videoDuration
        }
    }
}
