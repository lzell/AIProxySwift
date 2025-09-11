//
//  ReplicateTrainingRequestBody.swift
//
//
//  Created by Lou Zell on 9/8/24.
//

import Foundation

nonisolated public struct ReplicateTrainingRequestBody<T: Encodable & Sendable>: Encodable, Sendable {

    public let destination: String
    public let input: T

    public init(destination: String, input: T) {
        self.destination = destination
        self.input = input
    }
}
