//
//  ReplicatePredictionRequestBody.swift
//
//
//  Created by Lou Zell on 8/27/24.
//

import Foundation

/// The request body for creating a Replicate prediction.
///
/// This type is used for both community models and official models.
/// When using with an official model, the `version` property can remain `nil`.
///
/// Community model reference: https://replicate.com/docs/reference/http#predictions.create
/// Official model reference: https://replicate.com/docs/reference/http#models.predictions.create
nonisolated public struct ReplicatePredictionRequestBody: Encodable {

    /// The replicate input schema, for example ReplicateSDXLInputSchema
    /// TThe input schema depends on what model you are running. To see the available inputs, click the "API" tab on the model you are running or get the model version and look at its `openapi_schema` property. For example, `stability-ai/sdxl` takes `prompt` as an input.
    public let input: Encodable

    /// You do not need to set this field if you are using an official model.
    /// For community models, set it to the ID of the model version that you want to run.
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

