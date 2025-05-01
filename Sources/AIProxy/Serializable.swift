//
//  Serializable.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

extension Encodable {
    func serialize(pretty: Bool = false) throws -> Data {
        let pretty = pretty || AIProxy.printRequestBodies
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        if pretty {
            encoder.outputFormatting.insert(.prettyPrinted)
        }
        return try encoder.encode(self)
    }

    func serialize(pretty: Bool = false) throws -> String {
        let data: Data = try self.serialize(pretty: pretty)
        guard let str = String(data: data, encoding: .utf8) else {
            throw AIProxyError.assertion("Could not get utf8 string representation of data")
        }
        return str
    }
}
