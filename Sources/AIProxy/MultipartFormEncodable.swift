//
//  MultipartFormEncodable.swift
//
//
//  Created by Lou Zell on 7/22/24.
//

import Foundation


protocol MultipartFormEncodable {
    var formFields: [FormField] { get}
}

enum FormField {
    case fileField(name: String, content: Data, contentType: String)
    case textField(name: String, content: String)
}

func formEncode(_ body: OpenAICreateTranscriptionRequestBody, _ boundary: String) -> Data {
    var encoded = Data()
    let u: (String) -> Data = { $0.data(using: .utf8)! }
    for field in body.formFields {
        switch field {
        case .fileField(name: let name, content: let content, contentType: let contentType):
            encoded += u("--\(boundary)\r\n")
            encoded += u("Content-Disposition: form-data; name=\"\(name)\"; filename=\"aiproxy.m4a\"\r\n")
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
