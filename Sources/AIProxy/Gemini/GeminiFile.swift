//
//  GeminiFile.swift
//
//
//  Created by Lou Zell on 10/24/24.
//

import Foundation

public struct GeminiFile: Decodable {
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
}

// MARK: - GeminiFile.State
extension GeminiFile {
    public enum State: String, Decodable {
        case processing = "PROCESSING"
        case active = "ACTIVE"
    }
}

// MARK: - GeminiFile.VideoMetadata
extension GeminiFile {
    public struct VideoMetadata: Decodable {
        public let videoDuration: String
    }
}
