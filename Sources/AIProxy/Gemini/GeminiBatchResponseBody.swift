//
//  GeminiBatchResponseBody.swift
//  AIProxy
//
//  Created by Natasha Murashev on 8/7/25.
//

import Foundation

/// Response body for a Gemini batch job
public struct GeminiBatchResponseBody: Decodable {
    /// The unique name/identifier for the batch job
    public let name: String
    
    /// The metadata containing batch job details
    public let metadata: BatchMetadata?
    
    /// Whether the operation is complete
    public let done: Bool?
    
    /// The response data when the batch is complete
    public let response: BatchResponse?
    
    public init(
        name: String,
        metadata: BatchMetadata? = nil,
        done: Bool? = nil,
        response: BatchResponse? = nil
    ) {
        self.name = name
        self.metadata = metadata
        self.done = done
        self.response = response
    }
}

extension GeminiBatchResponseBody {
    /// Convenience property to get the state from metadata
    public var state: BatchMetadata.State? {
        return metadata?.state
    }
    
    /// Convenience property to get the create time from metadata
    public var createTime: String? {
        return metadata?.createTime
    }
    
    /// Convenience property to get the update time from metadata
    public var updateTime: String? {
        return metadata?.updateTime
    }
    
    /// Convenience property to get the model from metadata
    public var model: String? {
        return metadata?.model
    }
    
    /// Convenience property to get the input config from metadata
    public var inputConfig: BatchMetadata.InputConfig? {
        return metadata?.inputConfig
    }
    
    /// Convenience property to get the output config from metadata
    public var outputConfig: BatchMetadata.OutputConfig? {
        return metadata?.output
    }
}

extension GeminiBatchResponseBody {
    public struct BatchMetadata: Decodable {
        public let type: String?
        public let model: String?
        public let displayName: String?
        public let inputConfig: InputConfig?
        public let output: OutputConfig?
        public let createTime: String?
        public let endTime: String?
        public let updateTime: String?
        public let batchStats: BatchStats?
        public let state: State?
        public let name: String?
        
        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case model
            case displayName
            case inputConfig
            case output
            case createTime
            case endTime
            case updateTime
            case batchStats
            case state
            case name
        }
        
        public init(
            type: String? = nil,
            model: String? = nil,
            displayName: String? = nil,
            inputConfig: InputConfig? = nil,
            output: OutputConfig? = nil,
            createTime: String? = nil,
            endTime: String? = nil,
            updateTime: String? = nil,
            batchStats: BatchStats? = nil,
            state: State? = nil,
            name: String? = nil
        ) {
            self.type = type
            self.model = model
            self.displayName = displayName
            self.inputConfig = inputConfig
            self.output = output
            self.createTime = createTime
            self.endTime = endTime
            self.updateTime = updateTime
            self.batchStats = batchStats
            self.state = state
            self.name = name
        }
    }
    
    public struct BatchResponse: Decodable {
        public let type: String?
        public let responsesFile: String?
        
        enum CodingKeys: String, CodingKey {
            case type = "@type"
            case responsesFile
        }
        
        public init(type: String? = nil, responsesFile: String? = nil) {
            self.type = type
            self.responsesFile = responsesFile
        }
    }
}

extension GeminiBatchResponseBody.BatchMetadata {
    public enum State: String, Decodable {
        case unspecified = "BATCH_STATE_UNSPECIFIED"
        case pending = "BATCH_STATE_PENDING"
        case running = "BATCH_STATE_RUNNING"
        case succeeded = "BATCH_STATE_SUCCEEDED"
        case failed = "BATCH_STATE_FAILED"
        case cancelled = "BATCH_STATE_CANCELLED"
        case expired = "BATCH_STATE_EXPIRED"
    }
    
    public struct InputConfig: Decodable {
        public let fileName: String?
        
        public init(fileName: String?) {
            self.fileName = fileName
        }
    }
    
    public struct OutputConfig: Decodable {
        public let responsesFile: String?
        
        public init(responsesFile: String?) {
            self.responsesFile = responsesFile
        }
    }
    
    public struct BatchStats: Decodable {
        public let requestCount: String?
        public let successfulRequestCount: String?
        
        public init(requestCount: String?, successfulRequestCount: String?) {
            self.requestCount = requestCount
            self.successfulRequestCount = successfulRequestCount
        }
    }
}
