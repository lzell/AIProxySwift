//
//  Deserializable.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

extension Decodable {
    static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

    static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
    }
}
