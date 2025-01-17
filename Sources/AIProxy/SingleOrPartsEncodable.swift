//
//  SingleOrPartsEncodable.swift
//  AIProxy
//
//  Created by Lou Zell on 1/16/25.
//

protocol SingleOrPartsEncodable {
    var encodableItem: any Encodable { get }
}

extension SingleOrPartsEncodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.encodableItem)
    }
}
