//
//  EachAIRunModelRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 7/26/25.
//

import Foundation

public struct EachAICreatePredictionRequestBody<T: Encodable>: Encodable {
    public let input: T
    public let model: String
    public let version: String

    public init(
        input: T,
        model: String,
        version: String
    ) {
        self.input = input
        self.model = model
        self.version = version
    }
}
