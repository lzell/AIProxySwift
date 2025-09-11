//
//  FalInitiateUploadRequestBody.swift
//
//
//  Created by Lou Zell on 10/3/24.
//

import Foundation

nonisolated struct FalInitiateUploadRequestBody: Encodable {
    let contentType: String
    let fileName: String

    private enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case fileName = "file_name"
    }
}
