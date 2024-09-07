//
//  ReplicateTrainingRequestBody.swift
//
//
//  Created by Lou Zell on 9/8/24.
//

import Foundation

public struct ReplicateTrainingRequestBody<T: Encodable>: Encodable {

    public let destination: String
    public let input: T

    public init(destination: String, input: T) {
        self.destination = destination
        self.input = input
    }

    func serialize() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
