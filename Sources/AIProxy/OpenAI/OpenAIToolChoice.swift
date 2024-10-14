//
//  OpenAIToolChoice.swift
//  
//
//  Created by Lou Zell on 10/13/24.
//

import Foundation

/// Controls which (if any) tool is called by the model.
public enum OpenAIToolChoice: Encodable {

    /// The model will not call any tool and instead generates a message.
    /// This is the default when no tools are present in the request body
    case none

    /// The model can pick between generating a message or calling one or more tools.
    /// This is the default when tools are present in the request body
    case auto

    /// The model must call one or more tools
    case required

    /// Forces the model to call a specific tool
    case specific(functionName: String)

    private enum RootKey: CodingKey {
        case type
        case function
    }

    private enum FunctionKey: CodingKey {
        case name
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .none:
            var container = encoder.singleValueContainer()
            try container.encode("none")
        case .auto:
            var container = encoder.singleValueContainer()
            try container.encode("auto")
        case .required:
            var container = encoder.singleValueContainer()
            try container.encode("required")
        case .specific(let functionName):
            var container = encoder.container(keyedBy: RootKey.self)
            try container.encode("function", forKey: .type)
            var functionContainer = container.nestedContainer(
                keyedBy: FunctionKey.self,
                forKey: .function
            )
            try functionContainer.encode(functionName, forKey: .name)
        }
    }
}
