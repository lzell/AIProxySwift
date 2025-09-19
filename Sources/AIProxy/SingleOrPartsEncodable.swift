//
//  SingleOrPartsEncodable.swift
//  AIProxy
//
//  Created by Lou Zell on 1/16/25.
//

nonisolated protocol SingleOrPartsEncodable {
    var encodableItem: any Encodable & Sendable { get }
}

extension SingleOrPartsEncodable {
    nonisolated public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.encodableItem)
    }
}
