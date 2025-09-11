//
//  GeminiFileUploadRequestBody.swift
//
//
//  Created by Lou Zell on 10/23/24.
//

import Foundation

nonisolated public struct GeminiFileUploadRequestBody {

    let fileData: Data
    let mimeType: String

    func serialize(withBoundary boundary: String) -> Data {
        var encoded = Data()
        let u: (String) -> Data = { $0.data(using: .utf8)! }
        encoded += u("--\(boundary)\r\n")
        encoded += u("Content-Type: application/json; charset=utf-8\r\n\r\n")
        encoded += u("{\"file\":{\"mimeType\":\"\(self.mimeType)\"}}\r\n")
        encoded += u("--\(boundary)\r\n")
        encoded += u("Content-Type: \(self.mimeType)\r\n\r\n")
        encoded += self.fileData
        encoded += u("\r\n")
        encoded += u("--\(boundary)--")
        return encoded
   }
}
