//
//  Deserializable.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import Foundation

protocol Deserializable where Self: Decodable {
    static func deserialize(from data: Data) throws -> Self
    static func deserialize(from str: String) throws -> Self
}

extension Deserializable {
    static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: data)
    }

    static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
    }
}
