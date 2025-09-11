//
//  MultipartFormEncodable.swift
//
//
//  Created by Lou Zell on 7/22/24.
//

import Foundation


nonisolated public protocol MultipartFormEncodable: Sendable {
    var formFields: [FormField] { get}
}

nonisolated public enum FormField: Sendable {
    case fileField(name: String, content: Data, contentType: String, filename: String)
    case textField(name: String, content: String)
}

nonisolated func formEncode(_ body: MultipartFormEncodable, _ boundary: String) -> Data {
    var encoded = Data()
    let u: (String) -> Data = { $0.data(using: .utf8)! }
    for field in body.formFields {
        switch field {
        case .fileField(
            name: let name,
            content: let content,
            contentType: let contentType,
            filename: let filename
        ):
            encoded += u("--\(boundary)\r\n")
            encoded += u("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
            encoded += u("Content-Type: \(contentType)\r\n\r\n")
            encoded += content
            encoded += u("\r\n")
        case .textField(name: let name, content: let content):
            encoded += u("--\(boundary)\r\n")
            encoded += u("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            encoded += u(content)
            encoded += u("\r\n")
        }
    }
    encoded += u("--\(boundary)--")
    return encoded
}
