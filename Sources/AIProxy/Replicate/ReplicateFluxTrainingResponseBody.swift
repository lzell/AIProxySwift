//
//  ReplicateTrainingResponseBodyDEPRECATE.swift
//
//
//  Created by Lou Zell on 9/8/24.
//

import Foundation

public struct ReplicateTrainingResponseBodyDEPRECATE: Decodable {
    public let getURL: URL
    public let cancelURL: URL

    private enum RootCodingKey: CodingKey {
        case urls
    }

    private enum NestedCodingKey: CodingKey {
        case cancel
        case get
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKey.self)
        let nestedContainer = try container.nestedContainer(keyedBy: NestedCodingKey.self, forKey: .urls)
        self.getURL = try nestedContainer.decode(URL.self, forKey: .get)
        self.cancelURL = try nestedContainer.decode(URL.self, forKey: .cancel)
    }

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
