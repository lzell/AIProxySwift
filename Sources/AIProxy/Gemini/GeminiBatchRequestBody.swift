//
//  GeminiBatchRequestBody.swift
//  AIProxy
//
//  Created by Natasha Murashev on 8/7/25.
//

import Foundation

/// Request body for creating a Gemini batch job
public struct GeminiBatchRequestBody: Encodable {
    /// The uploaded file name/ID
    public let fileName: String
    /// A human-readable name for the batch job
    public let displayName: String
    
    public init(
        fileName: String,
        displayName: String
    ) {
        self.fileName = fileName
        self.displayName = displayName
    }
    
    private enum CodingKeys: String, CodingKey {
        case batch
    }
    
    private enum BatchKeys: String, CodingKey {
        case displayName = "display_name"
        case inputConfig = "input_config"
    }
    
    private enum InputConfigKeys: String, CodingKey {
        case fileName = "file_name"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var batchContainer = container.nestedContainer(keyedBy: BatchKeys.self, forKey: .batch)
        
        try batchContainer.encode(displayName, forKey: .displayName)
        
        var inputConfigContainer = batchContainer.nestedContainer(keyedBy: InputConfigKeys.self, forKey: .inputConfig)
        try inputConfigContainer.encode(fileName, forKey: .fileName)
    }
}