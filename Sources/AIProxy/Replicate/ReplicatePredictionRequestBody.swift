//
//  ReplicatePredictionRequestBody.swift
//
//
//  Created by Lou Zell on 8/27/24.
//

import Foundation

/// The request body for creating a Replicate prediction:
/// https://replicate.com/docs/reference/http#create-a-prediction
public struct ReplicatePredictionRequestBody: Encodable {
    /// The replicate input schema, for example ReplicateSDXLInputSchema
    public let input: Encodable

    /// The version of the model to run
    public let version: String?

    public init(
        input: any Encodable,
        version: String? = nil
    ) {
        self.input = input
        self.version = version
    }

    private enum RootKey: CodingKey {
        case input
        case version
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        try container.encode(self.input, forKey: .input)
        try container.encodeIfPresent(self.version, forKey: .version)
    }
}

